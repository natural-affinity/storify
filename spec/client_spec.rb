require 'spec_helper'

describe Storify::Client do
  before(:all) do
    @client = Storify::Client.new(:api_key => @api_key, :username => @username)
    @client.auth(get_password)
  end

  context ".new" do
    it "should accept a hash of credentials (api_key, username, token)" do
      clients = [Storify::Client.new(:api_key => 'k', :username => 'u', :token => 't'),
                 Storify::Client.new('api_key' => 'k', 'username' => 'u', 'token' => 't')]

      clients.each do |c|
        c.api_key.should == 'k'
        c.username.should == 'u'
        c.token.should == 't'
      end
    end

    it "should accept a configuration block of credentials" do
      client = Storify::Client.new do |config|
        config.api_key = 'YOUR API KEY'
        config.username = 'YOUR USERNAME'
        config.token = 'YOUR AUTH TOKEN'
      end

      client.api_key.should == 'YOUR API KEY'
    end

    it "should raise an exception for unknown credentials" do
      expect {Storify::Client.new(:unknown => 'value')}.to raise_exception
      expect {Storify::Client.new {|config| config.unknown = ''}}.to raise_exception
    end
  end

  context "GET /stories/:username" do
    it "should get all stories for a specific user" do
      @client.userstories(@username).length.should >= 2
    end

    it "should accept endpoint options (version, protocol)" do
      options = {:version => :v1, :protocol => :insecure}
      @client.userstories(@username, options: options).length.should >= 2
    end

    it "should accept paging options (Pager)" do
      pager = Storify::Pager.new(page: 1, max: 1, per_page: 10)
      stories = @client.userstories('joshuabaer', pager: pager)
      stories.length.should == 10
    end
  end

  context "GET /stories/:username/:slug" do
    before(:all) do
      puts "Enter a Story-Slug for your Account:"
      @slug = STDIN.gets.chomp
    end

    it "should get a specific story for a user (all pages)" do
      @client.story(@slug).elements.length.should == 3
    end

    it "should accept endpoint options (version, protocol)" do
      options = {:version => :v1, :protocol => :insecure}
      @client.story(@slug, options: options).elements.length.should == 3
    end

    it "should accept paging options (Page)" do
      pager = Storify::Pager.new(page: 2, max: 3)
      story = @client.story('austin-startup-digest-for-december-9-2014', 'joshuabaer', pager: pager)
      story = story.to_s

      ['408651138632667136', '409182832234213376'].each {|s| story.include?(s).should be_true }
     end
  end

  context "POST /stories/:username/:story-slug/editslug" do
    before(:all) do
      puts "Enter a Story-Slug for your Account:"
      @slug1 = STDIN.gets.chomp

      puts "Enter a New Unique Story-Slug for your Account"
      @slug2 = STDIN.gets.chomp
    end

    it "should respond with the new slug name (on a successful change)" do
      @client.edit_slug(@username, @slug1, @slug2).should == @slug2
      @client.edit_slug(@username, @slug2, @slug1).should == @slug1
    end

    it "should accept endpoint options (version, protocol)" do
      opts = {:version => :v1, :protocol => :insecure}
      @client.edit_slug(@username, @slug1, @slug2, options: opts).should == @slug2
      @client.edit_slug(@username, @slug2, @slug1, options: opts).should == @slug1
    end
  end

  context "GET /users/:username" do
    it "should get a specific user's profile" do
      @client.profile(@username).username.should == @username
    end
  end

  context "POST /stories/:username/:slug/publish" do
    it "should raise an exception if a story is not provided" do
      expect{@client.publish(nil)}.to raise_exception
    end

    it "should raise an exception if the story is not found" do
      story = Storify::Story.new.extend(Storify::StoryRepresentable)
      author = Storify::User.new.extend(Storify::UserRepresentable)
      author.username = 'rtejpar'
      story.author = author
      story.slug = 'does-not-exist-story'

      expect{@client.publish(story)}.to raise_exception(Storify::ApiError)
    end

    it "should raise an exception if you do not have permission to publish" do
      story = Storify::Story.new.extend(Storify::StoryRepresentable)
      author = Storify::User.new.extend(Storify::UserRepresentable)
      author.username = 'storify'
      story.author = author
      story.slug = 'storify-acquired-by-livefyre'

      expect{@client.publish(story)}.to raise_exception(Storify::ApiError)
    end

    it "should publish an existing story" do
      story = @client.story('test-story', @username)
      @client.publish(story).should == true
    end

    it "should ignore any changes to the story during a publish" do
      story = @client.story('no-embeds', @username)
      new_desc = "New Description #{Random.new(Random.new_seed).to_s}"
      old_desc = story.description

      story.description = new_desc
      story.description.should == new_desc
      @client.publish(story).should == true

      revised = @client.story('no-embeds', @username)
      revised.description.should == old_desc
    end

  end

  context "Serialization" do
    it "should allow a story to be serialized as text" do
      story = @client.story('austin-startup-digest-for-december-9-2014', 'joshuabaer')
      story.should_not eql ""
    end
  end
end
