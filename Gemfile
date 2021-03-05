# frozen_string_literal: true

source 'https://rubygems.org'

ruby RUBY_VERSION

DECIDIM_VERSION = '0.22.0'

gem 'decidim', DECIDIM_VERSION, git: 'https://github.com/decidim/decidim'
gem 'decidim-verifications_omniauth', git: 'https://github.com/belighted/decidim-module-verifications_omniauth', branch: DECIDIM_VERSION
gem 'decidim-term_customizer', git: 'https://github.com/belighted/decidim-module-term_customizer', branch: DECIDIM_VERSION
gem 'decidim-cookies', git: 'https://github.com/belighted/decidim-module-cookies', branch: DECIDIM_VERSION
gem 'decidim-navbar_links', git: 'https://github.com/belighted/decidim-module-navbar_links', branch: DECIDIM_VERSION
gem 'decidim-castings', git: 'https://github.com/belighted/decidim-module-castings', branch: DECIDIM_VERSION

# ----------------------------------------------------------------------------------------------------------------------
gem 'appsignal'
gem 'activerecord-session_store'
gem 'bootsnap'
gem 'deepl-rb'
gem 'http_logger'
gem 'omniauth-rails_csrf_protection'
gem "puma", "~> 4.3"
gem 'pry'
gem 'ruby-progressbar'
gem 'rubyzip', require: 'zip'
gem 'sentry-raven'
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'uglifier'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

gem 'dotenv-rails'

group :development, :test do
  gem 'faker', '~> 1.9'
  gem 'byebug', '~> 11.0', platform: :mri
  gem 'decidim-dev', DECIDIM_VERSION
  gem 'pry-rails'
  gem 'webdrivers'
end

group :development do
  gem 'capistrano', '~> 3.10', require: false
  gem 'capistrano-rails', '~> 1.6', require: false
  gem 'capistrano-rbenv', '~> 2.2', require: false
  gem 'capistrano-sidekiq', '2.0.0.beta5', require: false
  gem 'capistrano3-puma', require: false
  gem "capistrano-db-tasks", require: false
  gem 'letter_opener_web', '~> 1.3'
  gem 'listen', '~> 3.1'
  gem 'spring', '~> 2.0'
  gem 'spring-watcher-listen', '~> 2.0'
  gem 'web-console', '~> 3.5'
end

group :production do
  # gem 'dalli-elasticache'
  gem 'fog-aws'
  # gem 'newrelic_rpm'
  # gem 'newrelic-infinite_tracing'
end

group :test do
  gem 'database_cleaner-active_record'
end
