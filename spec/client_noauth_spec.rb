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
end