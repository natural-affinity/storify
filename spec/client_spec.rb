require 'spec_helper'

describe Storify::Client do
  before(:all) do
    @client = Storify::Client.new(@api_key, @username)
    @client.auth(get_password)
  end

  it "should get the first page of a users stories" do
    @client.stories(:world => false).deserialize.should_not be_nil
  end

  it "should get a specific "

end
