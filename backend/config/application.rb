# frozen_string_literal: true

require_relative "boot"

require "rails/all"
require "csv"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Load dotenv only in development or test environment
Dotenv::Rails.load if %w[development test].include? ENV["RAILS_ENV"]

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.generators do |generator|
      generator.test_framework :rspec
    end

    config.active_job.queue_adapter = :sidekiq

    config.autoload_paths << "#{root}/packs/oauth/app"
    config.autoload_paths << "#{root}/packs/demo_pack/app"
    config.active_record.yaml_column_permitted_classes = [Symbol, Date, Time, ActiveSupport::TimeWithZone,
                                                          ActiveSupport::TimeZone
]
  end
end
