require 'spec_helper'

# These methods did not work with authentication,
# so they have been forced to not use the auth token

describe "Storify::Client -- Unauthenticated" do
  before(:each) do
    @client = Storify::Client.new(:api_key => @api_key, :username => @username)
    @options = {:version => :v1, :protocol => :insecure}
  end

  context "GET /stories" do
    it "should get all stories until the maximum" do
      @client.stories.length.should > 400
    end

    it "should accept endpoint options (version, protocol)" do
      @client.stories(options: @options).length.should > 400
    end

    it "should accept paging options (Pager)" do
      pager = Storify::Pager.new(page: 1, max: 2, per_page: 20)
      @client.stories(pager: pager).length.should == 40
    end
  end

  context "GET /stories/browse/latest" do
    it "should get all the latest stories until the maximum" do
      @client.latest.length.should > 400
    end

    it "should accept endpoint options (version, protocol)" do
      @client.latest(options: @options).length > 400
    end

    it "should get the top 20 stories" do
      pager = Storify::Pager.new(page: 1, max: 1, per_page: 20)
      @client.latest(pager: pager).length.should == 20
    end
  end

  context "GET /stories/browse/featured" do
    it "should get all the featured stories until the maximum" do
      @client.featured.length.should > 400
    end

    it "should accept endpoint options (version, protocol)" do
      @client.featured(options: @options).length > 400
    end

    it "should get the top 20 featured stories" do
      pager = Storify::Pager.new(page: 1, max: 1, per_page: 20)
      @client.featured(pager: pager).length.should == 20
    end
  end

  context "GET /stories/browse/popular" do
    it "should get all the popular stories until the maximum" do
      @client.popular.length.should > 400
    end

    it "should accept endpoint options (version, protocol)" do
      @client.popular(options: @options).length > 400
    end

    it "should get the top 15 popular stories" do
      p = Storify::Pager.new(page: 1, max: 1, per_page: 15)
      @client.popular(pager: p).length.should == 15
    end
  end

  context "GET /stories/browse/topic/:topic" do
    it "should get all stories with a topic until the maximum" do
      @client.topic('nfl-playoffs').length.should > 1
    end

    it "should accept endpoint options (version, protocol)" do
      @client.topic('nfl-playoffs', options: @options).length.should > 1
    end

    it "should get the top 10 stories for a topic" do
      p = Storify::Pager.new(page: 1, max: 1, per_page: 10)
      @client.topic('nfl-playoffs', pager: p).length.should == 10
    end

    it "should raise an exception is the topic is not found" do
      expect{@client.topic('does-not-exist-topic')}.to raise_exception(Storify::ApiError)
    end
  end
end