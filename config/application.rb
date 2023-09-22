require_relative "boot"

require "rails/all"

# Shows elasticsearch info in log files
require 'elasticsearch/rails/instrumentation'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LifeJournal
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


    # This prevents a cascade of warning messages every time the dev db is seeded or tests are run
    config.active_storage.variant_processor = ImageProcessing::MiniMagick

    # Only show the ActionText format options that are wanted
    # config.after_initialize do
    #   config.action_text = {
    #     # Other options...

    #     # Customize Trix toolbar options
    #     trix: {
    #       toolbar: {
    #         # Keep the formatting options you want
    #         bold: true,
    #         italic: true,
    #         link: true,
    #         # Omit the ones you want to remove
    #         bullet_list: false,
    #         number_list: false,
    #         quote: false,
    #       }
    #     }
    #   }
    # end
  end
end
