require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Joe
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Singapore'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.

    # Precompile additional assets
    config.assets.precompile += %w( .svg .eot .woff .ttf )
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts', 'vendor')

    # config.middleware.insert_before 0, "Rack::Cors" do
    #   allow do
    #     origins '*' # on production, use the line below instead
    #     #   origins 'localhost:3001', 'myfabulousapp.com'
    #     resource '*', :headers => :any, :methods => [:get, :post, :delete, :put, :head]
    #   end
    # end

    config.to_prepare do
      DeviseController.respond_to :html, :json
    end


    require './lib/twilio_module.rb'
    require './lib/chikka_module.rb'
  end
end
