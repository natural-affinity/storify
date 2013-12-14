require 'json'
require 'rest-client'
RestClient.log = './restclient.log'

module Storify
  class Client
    # define end of content example
    EOC = {'content' => {'stories' => [], 'elements' => [], 'users' => []}}

    attr_accessor :api_key, :username, :token

    def initialize(options = {})
      options.each do |k, v|
        send(:"#{k}=", v)
      end

      yield self if block_given?
    end

    def auth(password, options: {})
      endpoint = Storify::endpoint(version: options[:version], method: :auth)
      data = call(endpoint, :POST, params: {password: password})
      @token = data['content']['_token']

      self
    end

    def stories(pager: nil, options: {})
      story_list(:stories, pager, options: options, use_auth: false)
    end

    def latest(pager: nil, options: {})
      story_list(:latest, pager, options: options, use_auth: false)
    end

    def featured(pager: nil, options: {})
      story_list(:featured, pager, options: options, use_auth: false)
    end

    def popular(pager: nil, options: {})
      story_list(:popular, pager, options: options, use_auth: false)
    end

    def topic(topic, pager: nil, options: {})
      story_list(:topic, pager, options: options, params: {':topic' => topic})
    end

    def search(criteria, pager: nil, options: {})
      u = {'q' => criteria}
      story_list(:search, pager, options: options, use_auth: false, uparams: u)
    end

    def userstories(username = @username, pager: nil, options: {})
      params = {':username' => username}
      story_list(:userstories, pager, options: options, params: params)
    end

    def story(slug, username = @username, pager: nil, options: {})
      params = {':username' => username, ':slug' => slug}
      endpoint = Storify::endpoint(version: options[:version],
                                   protocol: options[:protocol],
                                   method: :userstory,
                                   params: params)

      pager = pager ||= Pager.new

      story = nil
      elements = []

      begin
        data = call(endpoint, :GET, paging: pager.to_hash)
        story = Story.new(data['content']) if story.nil?

        # create elements
        data['content']['elements'].each do |e|
          story.add_element(Element.new(e))
        end

        pager.next
      end while pager.has_pages?(data['content']['elements'])

      story
    end

    def edit_slug(username = @username, old_slug, new_slug, options: {})
      params = {':username' => username, ':slug' => old_slug}
      endpoint = Storify::endpoint(version: options[:version],
                                   protocol: options[:protocol],
                                   method: :editslug,
                                   params: params)

      data = call(endpoint, :POST, params: {slug: new_slug})
      data['content']['slug']
    end

    def users(pager: nil, options: {})
      endpoint = Storify::endpoint(version: options[:version],
                                   protocol: options[:protocol],
                                   method: :users)

      pager = pager ||= Pager.new
      users = []

      begin
        data = call(endpoint, :GET, paging: pager.to_hash, use_auth: false)
        content = data['content']

        content['users'].each do |s|
          json = JSON.generate(s)
          users << User.new.extend(UserRepresentable).from_json(json)
        end

        pager.next
      end while pager.has_pages?(content['users'])

      users
    end

    def authenticated
      !@token.nil?
    end


    private

    def story_list(method, pager, params: {}, options: {}, use_auth: true, uparams: {})
      endpoint = Storify::endpoint(version: options[:version],
                                   protocol: options[:protocol],
                                   method: method,
                                   params: params)

      pager = pager ||= Pager.new
      stories = []

      begin
        data = call(endpoint, :GET, paging: pager.to_hash, use_auth: use_auth, params: uparams)
        content = data['content']

        content['stories'].each do |s|
          stories << Story.new(s)
        end

        pager.next
      end while pager.has_pages?(content['stories'])

      stories
    end

    def call(endpoint, verb, params: {}, paging: {}, opts: {}, use_auth: true)
      raw = nil

      begin
        # add paging and auth query params
        params.merge!(paging)
        params[:username] = @username
        params[:api_key] = @api_key
        params[:_token] = @token if (authenticated && use_auth)

        case verb
        when :POST
          raw = RestClient.post endpoint, params, {:accept => :json}
        when :GET
          raw = RestClient.get endpoint, {:params => params}
        end
      rescue => e
        data = JSON.parse(e.response)
        error = data['error']

        return Storify::error(data['code'], error['message'], error['type'], end_of_content: EOC)
      end

      JSON.parse(raw)
    end
  end
end