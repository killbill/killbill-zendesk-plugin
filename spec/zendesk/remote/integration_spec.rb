require 'spec_helper'

class KillbillApiWithFakeGetAccountById < Killbill::Plugin::KillbillApi
  def initialize(*args)
    super(*args)
    @accounts = {}
  end

  def create_account(id, external_key, name, email)
    @accounts[id.to_s] = Killbill::Plugin::Model::Account.new(id, nil, nil, nil, external_key, name, 1, email, 1, 'USD', nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, false, true)
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
    external_key, kb_account_id = create_kb_account

    # Verify the initial state of our table
    Killbill::Zendesk::ZendeskUser.count.should == 0

    # Verify the account doesn't exist yet
    @plugin.updater.find_by_external_id(external_key).should be_nil

    # Send a creation event
    @plugin.on_event MockEvent.new(Killbill::Plugin::Model::ExtBusEventType.new(:ACCOUNT_CREATION), kb_account_id)

    # We should now verify the account exists, but we can't, due to indexing lag :/
    #@plugin.updater.find_by_external_id(external_key).email.should == email
    # Instead, we use our table
    Killbill::Zendesk::ZendeskUser.count.should == 1

    # Send an update event
    @plugin.on_event MockEvent.new(Killbill::Plugin::Model::ExtBusEventType.new(:ACCOUNT_CHANGE), kb_account_id)

    # Verify we didn't create dups
    #@plugin.updater.find_all_by_external_id(external_key).count.should == 1
    Killbill::Zendesk::ZendeskUser.count.should == 1

    # Create a new user
    external_key, kb_account_id = create_kb_account
    @plugin.on_event MockEvent.new(Killbill::Plugin::Model::ExtBusEventType.new(:ACCOUNT_CREATION), kb_account_id)

    Killbill::Zendesk::ZendeskUser.count.should == 2
  end

  private

  def create_kb_account
    external_key = Time.now.to_i.to_s + '-test'
    kb_account_id = Killbill::Plugin::Model::UUID.new(external_key)
    email = external_key + '@tester.com'
    @plugin.kb_apis.create_account(kb_account_id, external_key, 'Test tester', email)
    return external_key, kb_account_id
  end
end
