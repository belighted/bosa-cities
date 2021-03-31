# BOSA

Free Open-Source participatory democracy, citizen participation and open government for cities and organizations

This is the repository for the main application for BOSA, based on [Decidim](https://github.com/decidim/decidim).

It includes specificities for Belgian Federal Government, Regions and Citizen. 


## Development setup

You will need to do some steps before having the app working properly once you've deployed it:

* make local copy for `.env` based on `.env.example`
* make db setup via `bin/rails db:setup`
* start server: `bin/rails s`

## Development setup via docker

### Structure

There are following files related to docker setup for this project:

* `Dockerfile` - image definition for web app

* `docker-compose.yml` - services definition

* `.ops/.gitconfig` - you can setup here your GITHUB_TOKEN to fetch private repos

* `.ops/Aptfile` - list of project related packages required during build process

### Build process

* make a proper `.env` to connect to specific service:
```
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=postgres
DATABASE_HOST=postgres
DATABASE_PORT=5432
RUBY_VERSION=2.6.3
REDIS_URL=redis://redis:6379/1
```
*  Make local copy for `.ops/.gitconfig` based on the `.ops/gitconfig.example`

* create image for the app: `docker-compose build rails`

* make setup for the db: `docker-compose run rails bin/rails db:setup`

### Utilities

* run the rails container: `docker-compose up rails`

* run the sidekiq container: `docker-compose up sidekiq`

* run the tests: `docker-compose run -e RAILS_ENV=test rails bin/rspec spec`

* open container: `docker-compose run rails /bin/bash`

## Production setup

* Open a Rails console in the server: `bundle exec rails console`
* Create a System Admin user:
```ruby
user = Decidim::System::Admin.new(email: <email>, password: <password>, password_confirmation: <password>)
user.save!
```
*. Visit `<your app url>/system` and login with your system admin credentials
*. Create a new organization. Check the locales you want to use for that organization, and select a default locale.
*. Set the correct default host for the organization, otherwise the app will not work properly. Note that you need to include any subdomain you might be using.
*. Fill the rest of the form and submit it.

### [optional] Create an admin user for a brand new organization
It is already done by decidim seeds for default organization,
but when you create a new organization there would be no admin users in it.

```
o = Decidim::Organization.find(_YOUR_ORG_ID_)
user = Decidim::User.new(email: "admin@belighted.com")
password = "decidim123456"
user.update!(
    name: "Admin",
    nickname: 'admin',
    password: password,
    password_confirmation: password,
    organization: o,
    confirmed_at: Time.current,
    locale: I18n.default_locale,
    admin: true,
    tos_agreement: true,
    personal_url: '',
    about: '',
    accepted_tos_version: o.tos_version,
    admin_terms_accepted_at: Time.current
)
user.confirm
```

You're good to go!

## Capistrano deployment

You can deploy app via capistrano utils. Currently we support following stages: `staging`.

We have included support for:

* puma management
* sidekiq management via systemd

Commands:

* `bundle exec cap -T` - list of available capistrano tasks
* `bundle exec cap staging deploy` - deploy app to staging
* `BRANCH=master bundle exec cap staging deploy` - deploy specific branch to staging(default: master)

### Notes about for first deployment

If you intend to seed the database in production, it won't run in the production environment. It relies on Decidim::Faker that is available only on
development.
The procedure will be:
* set the environment as development
* run `bundle exec rake db:setup`
* set the environment back to production

Create a systemd service at user level to control sidekiq
In `/home/[YOUR_USER]/.config/systemd/user`, create a file called for example `sidekiq.service`
Setup the service
Then:
* Enable the service `systemctl --user enable sidekiq.service`
* Reload the daemon `systemctl --user daemon-reload`

Now you are able to start the service with `systemctl --user start sidekiq.service`.

