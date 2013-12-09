require 'json'
require 'rest-client'
#RestClient.log = './restclient.log'    

class Storify::Client
  attr_reader :api_key, :username, :token

  def initialize(api_key, username)
    @api_key = api_key
    @username = username
  end

  def auth(password)
    endpoint = Storify::auth

    begin 
      response = RestClient.post endpoint, {username: @username, password: password, api_key: @api_key},
                                           {:accept => :json}

      data = JSON.parse(response)
      @token = data['content']['_token']
    rescue => e
      data = JSON.parse(e.response)
      error = data['error']
      raise Storify::ApiError.new(data['code'], error['message'], error['type'])      
    end

    self
  end
end