require 'spec_helper'

describe Storify do
  it "should default to un-versioned https API access" do
    Storify::api.should eq 'https://api.storify.com'
  end

  it "should allow explicit un-versioned https or http for API access" do
    Storify::api(false).should eq 'http://api.storify.com'
    Storify::api(true).should eq 'https://api.storify.com'
  end

  it "should allow dynamic versioned http or https API access" do
    Storify::versioned_api.should eq 'https://api.storify.com/v1'
    Storify::versioned_api(:version => 2).should eq 'https://api.storify.com/v2'

    Storify::versioned_api(:secure => false, 
                           :version => 2).should eq 'http://api.storify.com/v2'
  end

  it "should retrieve the auth API endpoint" do
    Storify::auth.should eq 'https://api.storify.com/v1/auth'
  end

  it "should retrieve the stories API endpoint" do
    Storify::stories.should eq 'https://api.storify.com/v1/stories'
  end

  it "should retrieve the user-specific stories API endpoint" do
    Storify::userstories(@username).should eq "https://api.storify.com/v1/stories/#{@username}"
  end

  it "should retrieve a user-specific story API endpoint" do
    Storify::story(@username, "mystory").should eq "https://api.storify.com/v1/stories/#{@username}/mystory"
  end
end
