require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ServiceBackend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # system.yml 系统配置
    $system_config = YAML.load_file(Path.new(Rails.root) / 'config/system.yml')
    $system_config = JSON.parse $system_config.to_json, symbolize_names: true
    $system_config_env = $system_config[Rails.env.to_sym]

    # 系统队列配置
    $system_queue_config = ($system_config_env[:queue] || {}).collect {|key, value| [key.to_s.to_sym, value]}.to_h

    # Message queue
    # config.active_job.queue_adapter = :sidekiq
    # print($system_queue_config)?
    config.active_job.queue_adapter = ActiveJob::QueueAdapters::AsyncAdapter.new(
        **$system_queue_config
    )
    # config.active_job.queue_adapter = :sidekiq
	
	config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options, :scope]
      end
    end
	
  end
end
