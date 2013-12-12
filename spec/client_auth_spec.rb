require 'spec_helper'

describe Storify::Client do
  before(:each) do
    @client = Storify::Client.new(:api_key => @api_key, :username => @username)
  end

  context "Authentication" do
    it "should retrieve an auth token on success" do
      @client.auth(get_password).token.should_not be_nil
      @client.authenticated.should be_true
    end

    it "should raise an API error on failure" do
      expect{@client.auth('invalid_password')}.to raise_error(Storify::ApiError)
    end

    it "should accept endpoint options (version)" do
      options = {:version => :v1}
      @client.auth(get_password, options: options)
      @client.authenticated.should be_true
    end

    it "should ignore endpoint options (protocol, method)" do
      options = {:method => :unknown, :protocol => :insecure}
      @client.auth(get_password, options: options)
      @client.authenticated.should be_true
    end
  end
end