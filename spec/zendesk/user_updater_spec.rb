require 'spec_helper'

describe Killbill::Zendesk::UserUpdater do
  it 'should build the details line' do
    updater = Killbill::Zendesk::UserUpdater.new(nil, nil, nil)

    account = build_account(nil, nil, nil, nil, nil, nil)
    updater.build_details_field(account).should == ''

    account = build_account('493 Slro road', nil, nil, nil, nil, nil)
    updater.build_details_field(account).should == '493 Slro road'

    account = build_account('493 Slro road', nil, 'Fola', nil, nil, nil)
    updater.build_details_field(account).should == '493 Slro road, Fola'

    account = build_account('493 Slro road', nil, 'Fola', 'FG', nil, nil)
    updater.build_details_field(account).should == '493 Slro road, Fola, FG'

    account = build_account('493 Slro road', nil, 'Fola', 'FG', 140, nil)
    updater.build_details_field(account).should == '493 Slro road, Fola, FG, 140'

    account = build_account('493 Slro road', 'apt 33', 'Fola', 'FG', 140, nil)
    updater.build_details_field(account).should == '493 Slro road, apt 33, Fola, FG, 140'

    account = build_account('493 Slro road', 'apt 33', 'Fola', 'FG', 140, 'Floq')
    updater.build_details_field(account).should == '493 Slro road, apt 33, Fola, FG, 140, Floq'
  end

  private

  def build_account(address1, address2, city, state_or_province, postal_code, country)
    Killbill::Plugin::Model::Account.new(nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, address1, address2, nil, city, state_or_province, postal_code, country, nil, nil, nil)
  end
end
