require 'spec_helper'

class FakeJavaUserAccountApi
  attr_accessor :accounts

  def initialize
    @accounts = []
  end

  def get_account_by_id(id, context)
    @accounts.find { |account| account.id == id.to_s }
  end

  def get_account_by_key(external_key, context)
    @accounts.find { |account| account.external_key == external_key.to_s }
  end
end

describe Killbill::Zendesk::ZendeskPlugin do
  before(:each) do
    @plugin = Killbill::Zendesk::ZendeskPlugin.new
    @plugin.conf_dir = File.expand_path(File.dirname(__FILE__) + '../../../../')

    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG
    @plugin.logger = logger

    @account_api = FakeJavaUserAccountApi.new
    svcs = {:account_user_api => @account_api}
    @plugin.kb_apis = Killbill::Plugin::KillbillApi.new('zendesk', svcs)

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
    @plugin.on_event OpenStruct.new(:event_type => :ACCOUNT_CREATION, :account_id => kb_account_id)

    # We should now verify the account exists, but we can't, due to indexing lag :/
    #@plugin.updater.find_by_external_id(external_key).email.should == email
    # Instead, we use our table
    Killbill::Zendesk::ZendeskUser.count.should == 1

    # Send an update event
    @plugin.on_event OpenStruct.new(:event_type => :ACCOUNT_CHANGE, :account_id => kb_account_id)

    # Verify we didn't create dups
    #@plugin.updater.find_all_by_external_id(external_key).count.should == 1
    Killbill::Zendesk::ZendeskUser.count.should == 1

    # Create a new user
    external_key, kb_account_id = create_kb_account
    @plugin.on_event OpenStruct.new(:event_type => :ACCOUNT_CREATION, :account_id => kb_account_id)

    Killbill::Zendesk::ZendeskUser.count.should == 2
  end

  private

  def create_kb_account
    external_key = Time.now.to_i.to_s + '-test'
    kb_account_id = SecureRandom.uuid
    email = external_key + '@tester.com'

    account = Killbill::Plugin::Model::Account.new
    account.id = kb_account_id
    account.external_key = external_key
    account.email = email
    account.name = 'Integration spec'

    @account_api.accounts << account

    return external_key, kb_account_id
  end
end
