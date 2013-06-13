configure do
  # Usage: rackup -Ilib -E test
  if (development? or test?) and !Killbill::Zendesk::UserUpdaterInitializer.instance.initialized?
    require 'logger'
    Killbill::Zendesk::UserUpdaterInitializer.instance.initialize! File.expand_path(File.dirname(__FILE__) + '../../../../'),
                                                                   nil,
                                                                   Logger.new(STDOUT)
  end
end

after do
  # return DB connections to the Pool if required
  ActiveRecord::Base.connection.close
end

# curl -v -d'webrick=stupid' -XPUT http://127.0.0.1:9292/plugins/killbill-zendesk/users/6939c8c0-cf89-11e2-8b8b-0800200c9a66
put '/plugins/killbill-zendesk/users/:id' do
  zendesk_user_url = Killbill::Zendesk::UserUpdaterInitializer.instance.updater.update(params[:id])

  if zendesk_user_url
    redirect zendesk_user_url
  else
    status 500, "Unable to update Zendesk user for id #{params[:id]}"
  end
end

# curl -v http://127.0.0.1:9292/plugins/killbill-zendesk/users/6939c8c0-cf89-11e2-8b8b-0800200c9a66
# Given a Kill Bill account id or Zendesk user id, retrieve the Kill Bill - Zendesk mapping
get '/plugins/killbill-zendesk/users/:id', :provides => 'json' do
  if params[:id] =~ /[A-Fa-f0-9]{8}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{12}/
    mapping = Killbill::Zendesk::ZendeskUser.find_by_kb_account_id(params[:id])
  else
    mapping = Killbill::Zendesk::ZendeskUser.find_by_zd_user_id(params[:id])
  end

  if mapping
    mapping.to_json
  else
    status 404
  end
end
