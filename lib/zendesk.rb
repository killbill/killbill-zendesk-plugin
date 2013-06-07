require 'active_record'

require 'killbill'
require 'zendesk_api'

require 'zendesk/zendesk_user'
require 'zendesk/user_updater'

module Killbill::Zendesk
  class ZendeskPlugin < Killbill::Plugin::Notification

    # For testing
    attr_reader :updater

    def start_plugin
      super
      configure_zendesk
    end

    def on_event(event)
      @updater.update(event.account_id) if [:ACCOUNT_CREATION, :ACCOUNT_CHANGE].include?(event.event_type.enum)
    end

    private

    def configure_zendesk
      # Parse the config file
      begin
        @config = YAML.load_file("#{@conf_dir}/zendesk.yml")
      rescue Errno::ENOENT
        @logger.warn "Unable to find the config file #{@conf_dir}/zendesk.yml"
        return
      end

      client = ZendeskAPI::Client.new do |config|
        config.url = "https://#{@config[:zendesk][:subdomain]}.zendesk.com/api/v2"

        config.username = @config[:zendesk][:username]
        config.password = @config[:zendesk][:password]
        config.token = @config[:zendesk][:token]
        # Not yet available?
        #config.access_token = @config[:zendesk][:access_token]
        config.retry = true if @config[:zendesk][:retry]

        config.logger = @logger
      end

      @updater = UserUpdater.new(client, @kb_apis, @logger)
    end
  end
end
