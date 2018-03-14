class FacebookService

  def initialize
    @conn = Faraday.new 'https://graph.facebook.com/v2.12' do |conn|
            conn.request :json
            conn.adapter Faraday.default_adapter
        end

    response = @conn.post('/oauth/access_token',
                                   { client_id: ENV['FACEBOOK_APP_ID'],
                                     client_secret: ENV['FACEBOOK_APP_SECRET'],
                                     grant_type: "client_credentials"
                                   })
  
  end

end
