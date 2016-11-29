module Killbill::Zendesk
  class UserUpdaterInitializer
    include Singleton

    attr_reader :updater

    def initialize!(conf_dir, kb_apis, logger)
      # Parse the config file
      begin
        @config = YAML.load(ERB.new(File.read("#{conf_dir}/zendesk.yml")).result)
      rescue Errno::ENOENT
        logger.warn "Unable to find the config file #{conf_dir}/zendesk.yml"
        return
      end

      logger.log_level = Logger::DEBUG if (@config[:logger] || {})[:debug]

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

      require 'active_record'
      require 'active_record/bogacs'
      require 'arjdbc'

      ::ActiveRecord::ConnectionAdapters::ConnectionHandler.connection_pool_class = ::ActiveRecord::Bogacs::FalsePool
      db_config = @config[:database] || {
          :adapter              => :mysql,
          # See KillbillActivator#KILLBILL_OSGI_JDBC_JNDI_NAME
          :data_source          => Java::JavaxNaming::InitialContext.new.lookup('killbill/osgi/jdbc'),
          # Since AR-JDBC 1.4, to disable session configuration
          :configure_connection => false
      }
      ActiveRecord::Base.establish_connection(db_config)

      @updater = UserUpdater.new(client, kb_apis, logger)
    end

    def initialized?
      !@updater.nil?
    end
  end
end
