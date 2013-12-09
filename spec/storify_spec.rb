require 'spec_helper'

describe Storify do
  it "should have a base API URL" do
    Storify::BASE_URL.should eq 'https://api.storify.com'
  end
end
