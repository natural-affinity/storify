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
end
