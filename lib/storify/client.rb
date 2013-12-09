require 'json'
require 'rest-client'
RestClient.log = './restclient.log'    

class Storify::Client
  attr_reader :api_key, :username, :token, :raw

  def initialize(api_key, username)
    @api_key = api_key
    @username = username
  end

  def auth(password)
    endpoint = Storify::auth
    data = call(endpoint, :POST, {password: password})
    @token = data['content']['_token']

    self
  end

  def stories(slug: nil, world: false)
    # filter from general to specific
    endpoint = Storify::stories if world
    endpoint = Storify::userstories(@username) unless world
    endpoint = Storify::story(@username, slug) unless slug.nil?
    call(endpoint, :GET)

    self
  end

  def authenticated
    !@token.nil?
  end

  def deserialize
    JSON.parse(@raw)
  end


  private 
  
  def call(endpoint, verb, params = {}, opts = {})
    @raw = nil

    begin
      # inject auth params automatically (if available)
      params[:username] = @username
      params[:api_key] = @api_key
      params[:_token] = @token if authenticated

      case verb
      when :POST
        @raw = RestClient.post endpoint, params, {:accept => :json}
      else
        @raw = RestClient.get endpoint, {:params => params}
      end
    rescue => e
      @raw = e.response
      
      data = JSON.parse(e.response)
      error = data['error']
      raise Storify::ApiError.new(data['code'], error['message'], error['type']) 
    end

    deserialize
  end
end