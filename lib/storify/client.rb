require 'json'
require 'rest-client'
#RestClient.log = './restclient.log'

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
      data = call(endpoint, :POST, params: merge_params!(params: {password: password}))
      @token = data['content']['_token']

      self
    end

    %w(stories latest featured popular).each do |m|
      define_method(m) do |pager: nil, options: {}|
        story_list(m.to_sym, pager, options: options, use_auth: false)
      end
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
      first = true
      elements = []

      begin
        p = merge_params!(paging: pager.to_hash)
        data = call(endpoint, :GET, params: p)
        json = JSON.generate(data['content'])

        if story.nil?
          story = Story.new.extend(StoryRepresentable).from_json(json)
        else
          first = false
        end

        # create elements
        data['content']['elements'].each do |e|
          je = JSON.generate(e)
          story.elements << Element.new.extend(ElementRepresentable).from_json(je)
        end unless first

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

      data = call(endpoint, :POST, params: merge_params!(params: {slug: new_slug}))
      data['content']['slug']
    end

    def users(pager: nil, options: {})
      endpoint = Storify::endpoint(version: options[:version],
                                   protocol: options[:protocol],
                                   method: :users)

      pager = pager ||= Pager.new
      users = []

      begin
        p = merge_params!(paging: pager.to_hash, use_auth: false)
        data = call(endpoint, :GET, params: p)
        content = data['content']

        content['users'].each do |s|
          json = JSON.generate(s)
          users << User.new.extend(UserRepresentable).from_json(json)
        end

        pager.next
      end while pager.has_pages?(content['users'])

      users
    end

    def profile(username = @username, options: {})
      endpoint = Storify::endpoint(version: options[:version],
                                   protocol: options[:protocol],
                                   method: :userprofile,
                                   params: {':username' => username})

      data = call(endpoint, :GET)
      json = JSON.generate(data['content'])

      User.new.extend(UserRepresentable).from_json(json)
    end

    def update_profile(user, options: {})
      raise "Not a User" unless user.is_a?(Storify::User)

      username = user.username
      endpoint = Storify::endpoint(version: options[:version],
                                   protocol: options[:protocol],
                                   method: :update_profile,
                                   params: {':username' => username})

      json = user.to_json
      data = call(endpoint, :POST, params: merge_params!(params: {:user => json}))

      true
    end

    def publish(story, options: {})
      story_update(story, :publish, options: options)
    end

    def save(story, options: {})
      story_update(story, :save, options: options)
    end

    def create(story, publish = false, options: {})
      raise "Not a Story" unless story.is_a?(Storify::Story)

      endpoint = Storify::endpoint(version: options[:version],
                                   protocol: options[:protocol],
                                   method: :create,
                                   params: {':username' => username})

      p = merge_params!(params: {:publish => publish, :story => story.to_json})
      data = call(endpoint, :POST, params: p)

      data['content']['slug']
    end

    def delete(slug, username = @username, options: {})
      endpoint = Storify::endpoint(version: options[:version],
                                   protocol: options[:protocol],
                                   method: :delete,
                                   params: {':username' => username,
                                            ':slug' => slug})

      data = call(endpoint, :POST, params: merge_params!)

      true
    end

    def authenticated
      !@token.nil?
    end


    private

    def story_update(story, method, options: {})
      # ensure we have a story w/slug and author
      raise "Not a Story" unless story.is_a?(Storify::Story)
      raise "No slug found" if story.slug.nil?
      raise "No author found" if (story.author.nil? || story.author.username.nil?)

      # extract author and slug
      slug = story.slug
      username = story.author.username
      endpoint = Storify::endpoint(version: options[:version],
                                   protocol: options[:protocol],
                                   method: method,
                                   params: {':username' => username,
                                            ':slug' => slug})

      # attempt to update (publish or save)
      json = story.to_json
      data = call(endpoint, :POST, params: merge_params!(params: {:story => json}))

      true
    end

    def story_list(method, pager, params: {}, options: {}, use_auth: true, uparams: {})
      endpoint = Storify::endpoint(version: options[:version],
                                   protocol: options[:protocol],
                                   method: method,
                                   params: params)

      pager = pager ||= Pager.new
      stories = []

      begin
        p = merge_params!(params: uparams, paging: pager.to_hash, use_auth: use_auth)

        data = call(endpoint, :GET, params: p)
        content = data['content']

        content['stories'].each do |s|
          json = JSON.generate(s)
          stories << Story.new.extend(StoryRepresentable).from_json(json)
        end

        pager.next
      end while pager.has_pages?(content['stories'])

      stories
    end

    def merge_params!(params: {}, paging: {}, use_auth: true)
      params.merge!(paging)
      params[:username] = @username
      params[:api_key] = @api_key
      params[:_token] = @token if (authenticated && use_auth)
      params
    end

    def call(endpoint, verb, params: {}, opts: {})
      raw = nil

      begin
        case verb
        when :POST
          raw = RestClient.post endpoint, params, {:accept => :json}
        when :GET
          raw = RestClient.get endpoint, {:params => params, :accept => :json}
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