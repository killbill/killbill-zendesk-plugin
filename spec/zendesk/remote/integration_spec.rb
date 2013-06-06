require 'spec_helper'

class KillbillApiWithFakeGetAccountById < Killbill::Plugin::KillbillApi
  def initialize(*args)
    super(*args)
    @accounts = {}
  end

  def create_account(id, name, email)
    @accounts[id.to_s] = Killbill::Plugin::Model::Account.new(id, nil, nil, nil, nil, name, 1, email, 1, 'USD', nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, false, true)
  end

  def get_account_by_id(id)
    @accounts[id.to_s]
  end
end

class MockEvent
  attr_reader :event_type
  attr_reader :account_id

  def initialize(event_type, account_id)
    @event_type = event_type
    @account_id = account_id
  end
end

describe Killbill::Zendesk::ZendeskPlugin do
  before(:each) do
    @plugin = Killbill::Zendesk::ZendeskPlugin.new
    @plugin.conf_dir = File.expand_path(File.dirname(__FILE__) + '../../../../')

    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG
    @plugin.logger = logger

    @plugin.kb_apis = KillbillApiWithFakeGetAccountById.new(nil)

    @plugin.start_plugin
  end

  after(:each) do
    @plugin.stop_plugin
  end

  it 'should be able to create and update a user' do
    kb_account_id = Killbill::Plugin::Model::UUID.new(Time.now.to_i.to_s + '-test')
    @plugin.kb_apis.create_account(kb_account_id, 'Test tester', 'test@tester.com')

    @plugin.on_event MockEvent.new(Killbill::Plugin::Model::ExtBusEventType.new(:ACCOUNT_CREATION), kb_account_id)
  end
end
