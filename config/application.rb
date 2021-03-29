require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DecidimAws
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.time_zone = "Europe/Paris"
    config.i18n.load_path += Dir[Rails.root.join('config/locales/**/*.yml').to_s]

    Redis.exists_returns_integer = false

    Decidim.unconfirmed_access_for = 0.days

    config.to_prepare do
      list = Dir.glob("#{Rails.root}/lib/extends/**/*.rb")
      concerns = list.select{|o| o.include?('concerns/')}
      if concerns.any?
        concerns.each {|c| puts "Concern: #{c}"}
        raise Exception, %Q{
        It looks like you're going to add an extension of a decidim concern.
        Putting it into lib/extends/ will lead to issues.
        Please override any of decidim concerns through classic monkey-patching and put them in the app/ folder.
      }
      end
      list.each {|override| require_dependency override}
    end

    initializer "Expire sessions" do
      Rails.application.config.session_store :active_record_store, key: '_decidim_session'
      ActiveRecord::SessionStore::Session.serializer = :json
    end

    Raven.configure do |config|
      config.logger = Raven::Logger.new(STDOUT)
      config.dsn = "https://c3d3d789cfd241db940fcd8c8c2b81eb@o26574.ingest.sentry.io/5471760" # ENV["SENTRY_DSN"]
      config.environments = %w[staging production bosa-production bosa-cities-production bosa-uat bosa-cities-uat]
      config.current_environment = ENV.fetch("SENTRY_CURRENT_ENV", "missing-env")

      config.async = lambda { |event|
        SentryJob.perform_later(event)
      }
    end

    # config.action_mailer.asset_host = "https://broom.osp.cat"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Basic auth
    config.basic_auth_required = ENV.fetch('BASIC_AUTH_REQUIRED', 1).to_i == 1
    config.basic_auth_username = ENV['BASIC_AUTH_USERNAME']
    config.basic_auth_password = ENV['BASIC_AUTH_PASSWORD']
  end
end
