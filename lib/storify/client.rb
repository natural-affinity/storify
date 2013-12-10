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
    endpoint = Storify::endpoint(method: :auth)
    data = call(endpoint, :POST, {password: password})
    @token = data['content']['_token']

    self
  end

  def userstories(username = @username)
    params = {':username' => username}
    endpoint = Storify::endpoint(method: :userstories, params: params)
    pager = add_pagination
    stories = []

    while data = call(endpoint, :GET, pager)
      content = data['content']
      break if content['stories'].length == 0

      content['stories'].each do |s|
        stories << Storify::Story.new(s)
      end

      pager[:page] += 1
    end

    stories
  end

  def story(slug, username = @username)
    params = {':username' => username, ':slug' => slug}
    endpoint = Storify::endpoint(method: :userstory, params: params)
    pager = add_pagination
    story = nil
    elements = []

    while data = call(endpoint, :GET, pager)
      story = Storify::Story.new(data['content']) if story.nil?
      break if data['content']['elements'].length == 0

      # create elements
      data['content']['elements'].each do |e|
        story.add_element(Storify::Element.new(e))
      end

      pager[:page] += 1
    end

    story
  end

  def authenticated
    !@token.nil?
  end

  def add_pagination(page = 1, per_page = 20)
    params = {}
    params[:page] = page
    params[:per_page] = per_page
    params
  end


  private

  def call(endpoint, verb, params = {}, opts = {})
    raw = nil

    begin
      # inject auth params automatically (if available)
      params[:username] = @username
      params[:api_key] = @api_key
      params[:_token] = @token if authenticated

      case verb
      when :POST
        raw = RestClient.post endpoint, params, {:accept => :json}
      when :GET
        raw = RestClient.get endpoint, {:params => params}
      end
    rescue => e
      raw = e.response
      
      data = JSON.parse(e.response)
      error = data['error']
      raise Storify::ApiError.new(data['code'], error['message'], error['type']) 
    end

    JSON.parse(raw)
  end
end