# encoding: utf-8
require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module LibraryApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = 'zh-CN'
    config.time_zone = 'Beijing'
    config.active_record.default_timezone = :local
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
    #config.autoload_paths += %W(#{config.root}/lib/support) 

    config.action_view.field_error_proc = Proc.new { |html_tag, instance| 
        if html_tag =~ /<(input|textarea|select)/
            html_field = Nokogiri::HTML::DocumentFragment.parse(html_tag)
            html_field.children.add_class 'error-border'
            html_field.to_s.html_safe
        else
            html_tag
        end
    }
  end
end
