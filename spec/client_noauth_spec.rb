require 'spec_helper'

# These methods did not work with authentication,
# so they have been forced to not use the auth token

describe "Storify::Client -- Unauthenticated" do
  before(:each) do
    @client = Storify::Client.new(@api_key, @username)
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
end