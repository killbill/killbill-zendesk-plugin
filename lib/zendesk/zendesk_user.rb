module Killbill::Zendesk
  class ZendeskUser < ActiveRecord::Base
    attr_accessible :kb_account_id,
                    :zd_user_id
  end
end
