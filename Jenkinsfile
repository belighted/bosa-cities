import groovy.transform.Field

@Field def job_base_name        = ""
@Field def project_name         = "bosa-cities"
@Field def code_path            = ""
@Field def build_number         = ""
@Field def jenkins_server_name  = ""
@Field def branch_name          = ""
@Field def docker_img_group     = "nexus-group.bosa.belighted.com"
@Field def docker_img_prod      = "nexus.asergo.com/2483/prod"
@Field def docker_int_base      = "registry-bosa-city-base.bosa.belighted.com"
@Field def docker_int_assets    = "registry-bosa-city-assets.bosa.belighted.com"
@Field def docker_int_app       = "registry-bosa-city.bosa.belighted.com"
@Field def docker_int_group     = "registry-bosa-docker.bosa.belighted.com"
@Field def kube_conf_url        = "https://2483-jier9.k8s.asergo.com:6443/"

podTemplate(
        label: 'docker-slave',
        containers: [
            containerTemplate(
                    name: 'docker',
                    image: 'docker:stable-dind',
                    ttyEnabled: true,
                    alwaysPullImage: true,
                    privileged: true,
                    command: "dockerd --host=unix:///var/run/docker.sock --host=tcp://0.0.0.0:2375 --storage-driver=overlay2 --insecure-registry=${docker_int_group} --insecure-registry=${docker_int_base} --insecure-registry=${docker_int_assets} --insecure-registry=${docker_int_app}"
            )
        ],
        volumes: [
                emptyDirVolume(memory: false, mountPath: '/var/lib/docker')
                //configMapVolume(mountPath: '/etc/docker', configMapName: 'docker-daemon-config')
        ]
) {
    try {
        node("docker-slave") {
            container("docker") {
                //sh "sleep 20m"
                stage('Project setup') {

                    //checking out the app code
                    echo 'Checkout the code..'
                    checkout scm
                    branch_name = env.BRANCH_NAME
                    build_number = env.BUILD_NUMBER
                    job_base_name = "${env.JOB_NAME}".split('/').last()
                    jenkins_server_name = env.BUILD_URL.split('/')[2].split(':')[0]
                    echo "Jenkins checkout from branch: $branch_name && $build_number"
                    echo "Running job ${job_base_name} on jenkins server ${jenkins_server_name}"
                    codePath = pwd()
                    sh "ls -lth"

                }

                switch (job_base_name){
                    case ~/^\d+\.\d+\.\d+$/:
                        stage('Promote image to prod'){
                            withDockerRegistry([credentialsId: 'nexus-docker-registry', url: "http://${docker_int_group}/"]) {
                                sh "docker pull ${docker_img_group}/bosa-city-assets:rc-${job_base_name}"
                                sh "docker pull ${docker_img_group}/bosa-city:rc-${job_base_name}"
                                sh "docker tag ${docker_img_group}/bosa-city-assets:rc-${job_base_name} ${docker_img_prod}/bosa-cities-assets:${job_base_name}"
                                sh "docker tag ${docker_img_group}/bosa-city:rc-${job_base_name} ${docker_img_prod}/bosa-cities:${job_base_name}"
                            }
                            withDockerRegistry([credentialsId: 'asergo-docker-registry', url: "https://${docker_img_prod}/"]){
                                sh "docker push ${docker_img_prod}/bosa-cities-assets:${job_base_name}"
                                sh "docker push ${docker_img_prod}/bosa-cities:${job_base_name}"
                            }
                        }
                        stage('Deploy app to prod'){
                            kubeDeploy(
                                    "v1.20.0",
                                    "kube-jenkins-robot",
                                    "${kube_conf_url}",
                                    "bosa-cities",
                                    "bosa-prod",
                                    ["bosa-cities", "bosa-cities-assets" ],
                                    ["${docker_img_prod}/bosa-cities:${job_base_name}", "${docker_img_prod}/bosa-cities-assets:${job_base_name}"]
                            )
                        }
                        stage('Deploy sidekiq to prod'){
                            kubeDeploy(
                                    "v1.20.0",
                                    "kube-jenkins-robot",
                                    "${kube_conf_url}",
                                    "bosa-cities-sidekiq",
                                    "bosa-prod",
                                    ["bosa-sidekiq" ],
                                    ["${docker_img_prod}/bosa-cities:${job_base_name}"]
                            )
                        }
                        break
                    case ~/^rc-\d+\.\d+\.\d+$/:
                        withDockerRegistry([credentialsId: 'nexus-docker-registry', url: "http://${docker_int_group}/"]) {
                            stage("Build test_runner") {
                                dir("ops/release/test_runner") {
                                    sh "./build"
                                    echo "Done!"
                                }

                            }
                            stage("Compile Assets") {
                                sh """
                            docker run -e RAILS_ENV=production --env-file ${codePath}/ops/release/test_runner/app_env -v ${codePath}/public:/app/public bosa-cities-testrunner:latest bundle exec rake assets:clean
                            docker run -e RAILS_ENV=production --env-file ${codePath}/ops/release/test_runner/app_env -v ${codePath}/public:/app/public bosa-cities-testrunner:latest bundle exec rake assets:precompile
                        """

                            }
                            stage("Build app image"){
                                switch (job_base_name){
                                    case ~/^\d+\.\d+\.\d+$/:
                                        sh "TAG=$job_base_name ${codePath}/ops/release/app/build"
                                        sh "TAG=$job_base_name ${codePath}/ops/release/assets/build"
                                        // This will push the assets image to registry
                                        pushToNexus(
                                                "nexus-docker-registry",
                                                "http://${docker_int_assets}/",
                                                "${docker_int_assets}/bosa-city-assets:$job_base_name"
                                        )
                                        // This will push the app image to registry
                                        pushToNexus(
                                                "nexus-docker-registry",
                                                "http://${docker_int_app}/",
                                                "${docker_int_app}/bosa-city:$job_base_name"
                                        )
                                        break
                                    case ~/^rc-\d+\.\d+\.\d+$/:
                                        sh "TAG=$job_base_name ${codePath}/ops/release/app/build"
                                        sh "TAG=$job_base_name ${codePath}/ops/release/assets/build"
                                        // This will push the assets image to registry
                                        pushToNexus(
                                                "nexus-docker-registry",
                                                "http://${docker_int_assets}/",
                                                "${docker_int_assets}/bosa-city-assets:$job_base_name"
                                        )
                                        // This will push the app image to registry
                                        pushToNexus(
                                                "nexus-docker-registry",
                                                "http://${docker_int_app}/",
                                                "${docker_int_app}/bosa-city:$job_base_name"
                                        )
                                        break
                                    default:
                                        sh "TAG=$job_base_name-$build_number ${codePath}/ops/release/app/build"
                                        sh "TAG=$job_base_name-$build_number ${codePath}/ops/release/assets/build"
                                        // This will push the assets image to registry
                                        pushToNexus(
                                                "nexus-docker-registry",
                                                "http://${docker_int_assets}/",
                                                "${docker_int_assets}/bosa-city-assets:${job_base_name}-${build_number}"
                                        )
                                        // This will push the app image to registry
                                        pushToNexus(
                                                "nexus-docker-registry",
                                                "http://${docker_int_app}/",
                                                "${docker_int_app}/bosa-city:${job_base_name}-${build_number}"
                                        )
                                        break
                                }
                            }
                        }
                        stage('Deploy app to uat'){
                            kubeDeploy(
                                    "v1.20.0",
                                    "kube-jenkins-robot",
                                    "${kube_conf_url}",
                                    "bosa-cities",
                                    "bosa-uat",
                                    ["bosa-cities", "bosa-cities-assets" ],
                                    ["${docker_img_group}/bosa-city:$job_base_name", "${docker_img_group}/bosa-city-assets:$job_base_name"]
                            )
                        }
                        stage('Deploy sidekiq to uat'){
                            kubeDeploy(
                                    "v1.20.0",
                                    "kube-jenkins-robot",
                                    "${kube_conf_url}",
                                    "bosa-cities-sidekiq",
                                    "bosa-uat",
                                    ["bosa-cities-sidekiq" ],
                                    ["${docker_img_group}/bosa-city:$job_base_name"]
                            )
                        }
                        break
                    default:
                        withDockerRegistry([credentialsId: 'nexus-docker-registry', url: "http://${docker_int_group}/"]) {
                            stage("Build test_runner") {
                                dir("ops/release/test_runner") {
                                    sh "./build"
                                    echo "Done!"
                                }

                            }
                            stage("Compile Assets") {
                                sh """
                            docker run -e RAILS_ENV=production --env-file ${codePath}/ops/release/test_runner/app_env -v ${codePath}/public:/app/public bosa-cities-testrunner:latest bundle exec rake assets:clean
                            docker run -e RAILS_ENV=production --env-file ${codePath}/ops/release/test_runner/app_env -v ${codePath}/public:/app/public bosa-cities-testrunner:latest bundle exec rake assets:precompile
                        """

                            }
                            stage("Build app image"){
                                switch (job_base_name){
                                    case ~/^\d+\.\d+\.\d+$/:
                                        sh "TAG=$job_base_name ${codePath}/ops/release/app/build"
                                        sh "TAG=$job_base_name ${codePath}/ops/release/assets/build"
                                        // This will push the assets image to registry
                                        pushToNexus(
                                                "nexus-docker-registry",
                                                "http://${docker_int_assets}/",
                                                "${docker_int_assets}/bosa-city-assets:$job_base_name"
                                        )
                                        // This will push the app image to registry
                                        pushToNexus(
                                                "nexus-docker-registry",
                                                "http://${docker_int_app}/",
                                                "${docker_int_app}/bosa-city:$job_base_name"
                                        )
                                        break
                                    case ~/^rc-\d+\.\d+\.\d+$/:
                                        sh "TAG=$job_base_name ${codePath}/ops/release/app/build"
                                        sh "TAG=$job_base_name ${codePath}/ops/release/assets/build"
                                        // This will push the assets image to registry
                                        pushToNexus(
                                                "nexus-docker-registry",
                                                "http://${docker_int_assets}/",
                                                "${docker_int_assets}/bosa-city-assets:$job_base_name"
                                        )
                                        // This will push the app image to registry
                                        pushToNexus(
                                                "nexus-docker-registry",
                                                "http://${docker_int_app}/",
                                                "${docker_int_app}/bosa-city:$job_base_name"
                                        )
                                        break
                                    default:
                                        sh "TAG=$job_base_name-$build_number ${codePath}/ops/release/app/build"
                                        sh "TAG=$job_base_name-$build_number ${codePath}/ops/release/assets/build"
                                        // This will push the assets image to registry
                                        pushToNexus(
                                                "nexus-docker-registry",
                                                "http://${docker_int_assets}/",
                                                "${docker_int_assets}/bosa-city-assets:${job_base_name}-${build_number}"
                                        )
                                        // This will push the app image to registry
                                        pushToNexus(
                                                "nexus-docker-registry",
                                                "http://${docker_int_app}/",
                                                "${docker_int_app}/bosa-city:${job_base_name}-${build_number}"
                                        )
                                        break
                                }
                            }
                        }
                        stage('Deploy app to dev'){
                            kubeDeploy(
                                    "v1.20.0",
                                    "kube-jenkins-robot",
                                    "${kube_conf_url}",
                                    "bosa-cities",
                                    "bosa-dev",
                                    ["bosa-cities", "bosa-cities-assets" ],
                                    ["${docker_img_group}/bosa-city:$job_base_name-$build_number", "${docker_img_group}/bosa-city-assets:$job_base_name-$build_number"]
                            )
                        }
                        stage('Deploy sidekiq to dev'){
                            kubeDeploy(
                                    "v1.20.0",
                                    "kube-jenkins-robot",
                                    "${kube_conf_url}",
                                    "bosa-cities-sidekiq",
                                    "bosa-dev",
                                    ["bosa-cities-sidekiq" ],
                                    ["${docker_img_group}/bosa-city:$job_base_name-$build_number"]
                            )
                        }
                        break
                }
            }
        }
    }
    catch (e) {
        // If there was an exception thrown, the build failed
        currentBuild.result = "FAILED"
        throw e
    }
}

// This method will help us push the docker image to Nexus Sonatype docker private registry
def pushToNexus(String registryCredId, String registryUrl, String image){
    withDockerRegistry([credentialsId: registryCredId, url: registryUrl]) {
        sh "docker push ${image}"
    }
}

// This method will help us trigger kubectl for a rolling update - no downtime expected
def kubeDeploy(String kubectlVersion, String credentialsId, String kubeServerUrl, String deployName, String namespace, List container, List image){
    try {

        // Install kubectl in the docke:stable-dind which is a alpine image, we do not want to bake the image
        sh """
           apk add curl
           curl -LO https://dl.k8s.io/release/${kubectlVersion}/bin/linux/amd64/kubectl
           install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
           kubectl version --client
           """
        // Using a Secret text in jenkins credentials see https://plugins.jenkins.io/kubernetes-cli/
        withKubeConfig([
                credentialsId: "${credentialsId}",
                serverUrl    : "${kubeServerUrl}"
        ]) {
            // if there are multiple containers in a pod we need to loop and update all.
            for (int i = 0; i < container.size() ; i++) {
                sh """
                   kubectl set image deployment/$deployName \
                                     ${container[i]}=${image[i]} \
                                     -n $namespace \
                                     --record
                   
                   """
            }
            // Checking how our deployment status is
            sh """
               kubectl rollout status deployment/${deployName} --timeout=180s -n ${namespace}
            """

        }
    } catch(e){
        currentBuild.result = "FAILED"
        throw e
    }
}