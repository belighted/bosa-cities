# Docker configurations

## Base image ([ops/base](./base))

The purpose of the base image is mostly to speed up the building of the working images.
It contains dependencies (binaries, gems,...) common to the various environments 
(local development/test, feature, staging, production).

It must be rebuilt and pushed to the Docker registry when the base Dockerfile is modified (e.g. when Ruby version is 
updated, or when binaries are added). It is also a good idea to rebuilt and push a new version from time to time in
order to install new or updated gems in the base image (this is not mandatory, but as explained above it will speed up
the building of the working images).

The base imaged can be built and pushed using the following command:

```shell
TAG=new_tag ./ops/base/build
```

When doing that, the base image tag in the Dockerfiles that use it has to be updated accordingly.

## Development ([ops/dev](./dev))

This directory contains all that should be needed to run BOSA locally with Docker.

Running:
```shell script
cd ops/dev
docker-compose up
```
should start all the needed services: MongoDB, Redis, Nginx reverse proxy, Rails app,
and Sidekick workers. Note that the very first time, an empty file named `app_env.secrets` should be created in
the `ops/dev` directory. This files is ignored by Git and will allow the developer to override the environment
variables defined by default in `app_env`.

## Release ([ops/release](./release))

This directory contains the Docker configuration files that are needed to build the images that
will be released either in feature, staging, or production environment (note that the `docker-compose.yml`
and `app_env` files are exclusively there for documentation purpose).

To build and push the application and assets images, run the following:

```shell script
# Build test_runner temporary image:
./ops/release/test_runner/build

# Use test_runner to compile assets:
docker run -e RAILS_ENV=production --env-file $PWD/ops/release/test_runner/app_env -v $PWD/public:/app/public bosa-testrunner:latest bundle exec rake assets:clean
docker run -e RAILS_ENV=production --env-file $PWD/ops/release/test_runner/app_env -v $PWD/public:/app/public bosa-testrunner:latest bundle exec rake assets:precompile

# Build and push app image:
TAG=some_tag ./ops/release/app/build

# Build and push assets image:
TAG=some_tag ./ops/release/assets/build
```
