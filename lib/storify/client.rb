require 'json'
require 'rest-client'
#RestClient.log = './restclient.log'

class Storify::Client
  attr_reader :api_key, :username, :token

  def initialize(api_key, username)
    @api_key = api_key
    @username = username
  end

  def auth(password, options: {})
    endpoint = Storify::endpoint(version: options[:version], method: :auth)
    data = call(endpoint, :POST, {password: password})
    @token = data['content']['_token']

    self
  end

  def userstories(username = @username, pager: nil, options: {})
    endpoint = Storify::endpoint(version: options[:version],
                                 protocol: options[:protocol],
                                 method: :userstories,
                                 params: {':username' => username})

    pager = Storify::Pager.new unless pager.is_a?(Storify::Pager)
    stories = []

    begin
      data = call(endpoint, :GET, pager.to_hash)
      content = data['content']

      content['stories'].each do |s|
        stories << Storify::Story.new(s)
      end

      pager.next
    end while pager.has_pages?(content['stories'])

    stories
  end

  def story(slug, username = @username, pager: nil, options: {})
    params = {':username' => username, ':slug' => slug}
    endpoint = Storify::endpoint(version: options[:version],
                                 protocol: options[:protocol],
                                 method: :userstory,
                                 params: params)

    pager = Storify::Pager.new unless pager.is_a?(Storify::Pager)
    story = nil
    elements = []

    begin
      data = call(endpoint, :GET, pager.to_hash)
      story = Storify::Story.new(data['content']) if story.nil?

      # create elements
      data['content']['elements'].each do |e|
        story.add_element(Storify::Element.new(e))
      end

      pager.next
    end while pager.has_pages?(data['content']['elements'])

    story
  end

  def authenticated
    !@token.nil?
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