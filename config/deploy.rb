# config valid for current version and patch releases of Capistrano
lock '~> 3.14.1'

require 'capistrano-db-tasks'

set :application, 'bosa'
set :branch, ENV.fetch('BRANCH', 'master')
set :repo_url, 'git@github.com:belighted/bosa-cities.git '

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/webuser/#{fetch(:application)}"

set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip

set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails puma pumactl sidekiq}
set :rbenv_roles, :all # default value

set :puma_init_active_record, true
set :puma_preload_app, true
set :puma_env, fetch(:rack_env, fetch(:rails_env))


set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }
set sidekiq_default_hooks: false

# sidekiq systemd options
set :sidekiq_service_unit_name, 'sidekiq'
set :sidekiq_service_unit_user, :webuser # :system
set :sidekiq_enable_lingering, true
set :sidekiq_lingering_user, nil

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, 'config/master.key', '.env', 'config/database.yml', 'config/credentials.yml.enc', 'config/newrelic.yml'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle',
       'public/system', 'public/uploads'

# Default value for default_env is {}
# set :default_env, { path: '/opt/ruby/bin:$PATH' }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5


# ________________ CAPISTRANO DB TASKS SETUP ________________
# if you want to remove the local dump file after loading
set :db_local_clean, true

# if you want to remove the dump file from the server after downloading
set :db_remote_clean, true

# if you want to exclude table from dump
set :db_ignore_tables, []

# if you want to exclude table data (but not table schema) from dump
set :db_ignore_data_tables, []

# configure location where the dump file should be created
set :db_dump_dir, "./db"

# If you want to import assets, you can change default asset dir (default = system)
# This directory must be in your shared directory on the server
set :assets_dir, %w(public/assets public/att)
set :local_assets_dir, %w(public/assets public/att)

# if you want to work on a specific local environment (default = ENV['RAILS_ENV'] || 'development')
# set :locals_rails_env, "production"

# if you are highly paranoid and want to prevent any push operation to the server
set :disallow_pushing, false

# if you prefer bzip2/unbzip2 instead of gzip
# set :compressor, :bzip2
# ________________ END OF CAPISTRANO DB TASKS SETUP ________________

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
set :ssh_options, keepalive: true, forward_agent: true
