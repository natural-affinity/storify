require 'spec_helper'

describe Storify::Client do
  before(:all) do
    @client = Storify::Client.new(@api_key, @username)
    @client.auth(get_password)

    puts "Enter a Story Id for your Account:"
    @story = STDIN.gets.chomp
  end

  context "GET /stories/:username" do
    it "should get all stories for a specific user" do
      @client.userstories(@username).length.should == 2
    end

    it "should accept endpoint options (version, protocol)" do
      options = {:version => :v1, :protocol => :insecure}
      @client.userstories(@username, options: options).length.should == 2
    end

    it "should accept paging options (Pager)" do
      pager = Storify::Pager.new(page: 1, max: 1, per_page: 10)
      stories = @client.userstories('joshuabaer', pager: pager)
      stories.length.should == 10
    end
  end

  context "GET /stories/:username/:slug" do
    it "should get a specific story for a user (all pages)" do
      @client.story(@story).elements.length.should == 3
    end

    it "should accept endpoint options (version, protocol)" do
      options = {:version => :v1, :protocol => :insecure}
      @client.story(@story, options: options).elements.length.should == 3
    end

    it "should accept paging options (Page)" do
      pager = Storify::Pager.new(page: 2, max: 3)
      story = @client.story('austin-startup-digest-for-december-9-2014', 'joshuabaer', pager: pager)
      story = story.to_s

      ['408651138632667136', '409182832234213376'].each {|s| story.include?(s).should be_true }
     end
  end

  it "should allow a story to be serialized as text" do
    story = @client.story('austin-startup-digest-for-december-9-2014', 'joshuabaer')
    story.should_not eql ""
  end
end
