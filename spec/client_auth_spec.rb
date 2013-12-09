require 'spec_helper'

describe "Storify::Client -- Authentication" do
  before(:all) do
    @client = Storify::Client.new(@api_key, @username)
  end

  it "should retrieve an auth token on success" do
    @client.auth(get_password).token.should_not be_nil
    @client.authenticated.should be_true
  end

  it "should raise an API error on failure" do
    expect{@client.auth('invalid_password')}.to raise_error(Storify::ApiError)
  end
end