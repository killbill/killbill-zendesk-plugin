module Killbill::Zendesk
  class UserUpdaterInitializer
    include Singleton

    attr_reader :updater

    def initialize!(conf_dir, kb_apis, logger)
      # Parse the config file
      begin
        @config = YAML.load_file("#{conf_dir}/zendesk.yml")
      rescue Errno::ENOENT
        @logger.warn "Unable to find the config file #{conf_dir}/zendesk.yml"
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

        config.logger = logger
      end

      if defined?(JRUBY_VERSION)
        # See https://github.com/jruby/activerecord-jdbc-adapter/issues/302
        require 'jdbc/mysql'
        Jdbc::MySQL.load_driver(:require) if Jdbc::MySQL.respond_to?(:load_driver)
      end

      ActiveRecord::Base.establish_connection(@config[:database])

      @updater = UserUpdater.new(client, kb_apis, logger)
    end

    def initialized?
      !@updater.nil?
    end
  end
end
