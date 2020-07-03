# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
# require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EvallyRecruitable
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.generators do |generate|
      generate.factory_bot suffix: 'factory'
    end

    config.env = Rails.application.config_for(:env)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.eager_load_paths << Rails.root.join('app', 'forms')
    config.eager_load_paths << Rails.root.join('app', 'policies')
    config.eager_load_paths << Rails.root.join('app', 'presenters')
    config.eager_load_paths << Rails.root.join('app', 'queries')
    config.eager_load_paths << Rails.root.join('app', 'serializers')
    config.eager_load_paths << Rails.root.join('app', 'services')

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    # config.api_only = true

    # Whitelist locales available for the application
    config.i18n.available_locales = %i[en pl]

    # Set default locale to something other than :en
    config.i18n.default_locale = :en

    # Set i18n fallbacks
    config.i18n.fallbacks = true

    # Default headers
    config.action_dispatch.default_headers = {
      'X-Frame-Options' => 'ALLOWALL',
    }

    # Action mailer settings
    config.action_mailer.asset_host = config.env.fetch(:recruitable).fetch(:host)
    config.action_mailer.default_url_options = { host: config.env.fetch(:core).fetch(:host) }

    # Active Job settings
    config.active_job.queue_adapter = :sidekiq

    logger = ActiveSupport::Logger.new(Rails.root.join('log', "active_job_#{Rails.env}.log"))
    logger.formatter = Logger::Formatter.new

    config.active_job.logger = ActiveSupport::TaggedLogging.new(logger)
  end
end
