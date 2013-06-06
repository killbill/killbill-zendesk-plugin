module Killbill::Zendesk
  class UserUpdater
    def initialize(client, kb_apis, logger)
      @client = client
      @kb_apis = kb_apis
      @logger = logger
    end

    def update(kb_account_id)
      kb_account = @kb_apis.get_account_by_id(kb_account_id)

      user = find_by_kb_account(kb_account)
      user = @client.users.create(:name => kb_account.name) if user.nil?

      user.name = kb_account.name
      user.external_id = kb_account.external_key || kb_account.id.to_s
      user.locale = kb_account.locale
      user.timezone = kb_account.time_zone
      user.email = kb_account.email
      user.phone = kb_account.phone
      user.details = "#{kb_account.address1},#{kb_account.address2},#{kb_account.city},#{kb_account.state_or_province},#{kb_account.postal_code},#{kb_account.country}"

      if user.save
        @logger.info "Successfully updated #{user.name} in Zendesk: #{user.url}"
      else
        @logger.warn "Unable to update #{user.name} in Zendesk: #{user.url}"
      end
    end

    private

    def find_by_kb_account(kb_account)
      zd_account = nil

      # TODO In the search results below, should we worry about potential dups?

      # First search by external_id, which is the safest method.
      # The external_id is either the account external key...
      if kb_account.external_key
        zd_account = @client.search(:query => "type:user external_id:#{kb_account.external_key}").first
      end
      return zd_account if zd_account

      # ...or the Kill Bill account id
      zd_account = @client.search(:query => "type:user external_id:#{kb_account.id}").first
      return zd_account if zd_account

      # At this point, we haven't matched this user yet. To reconcile it, use the email address which is guaranteed
      # to exist on the Zendesk side
      if kb_account.email
        zd_account = @client.search(:query => "type:user email:#{kb_account.email}").first
      end
      return zd_account if zd_account

      # We couldn't find a match - the account will be created
      nil
    end
  end
end
