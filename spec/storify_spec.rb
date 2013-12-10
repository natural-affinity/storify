require 'spec_helper'

describe Storify do
  context "API Protocols:" do
    it "should support http" do
      Storify::PROTOCOLS[:insecure].should == "http://"
    end

    it "should support secure http" do
      Storify::PROTOCOLS[:secure].should == "https://"
    end

    it "should default to secure http" do
      Storify::PROTOCOLS[:unknown].should == "https://"
    end
  end

  context "API Versions:" do
    it "should support Storify API v1" do
      Storify::ENDPOINTS[:v1].is_a?(Hash).should be_true
    end

    it "should fallback to Storify API v1" do
      Storify::ENDPOINTS[:unknown].is_a?(Hash).should be_true
    end
  end

  context "API v1 Endpoints Sub-Paths:" do
    it "should support a base URL for a version" do
      Storify::ENDPOINTS[:v1][:base].should == "api.storify.com/v1"
    end

    it "should default to the base URL" do
      Storify::ENDPOINTS[:unknown][:unknown].should == "api.storify.com/v1"
    end

    it "should support the Authentication endpoint" do
      Storify::ENDPOINTS[:v1][:auth].should == "/auth"
    end

    it "should support the User Stories endpoint" do
      Storify::ENDPOINTS[:v1][:userstories].should == "/stories/:username"
    end

    it "should support the Single Story endpoint" do
      Storify::ENDPOINTS[:v1][:userstory].should == "/stories/:username/:slug"
    end
  end

  context "API Endpoint URI Builder:" do
    it "should allow dynamic protocol selection" do
      Storify::endpoint(protocol: :secure).include?('https').should be_true
    end

    it "should allow dynamic version selection" do
      Storify::endpoint(version: :v1).include?('v1').should be_true
    end

    it "should allow dynamic endpoint selection" do
      Storify::endpoint(method: :auth).include?('/auth').should be_true
    end

    it "should allow dynamic parameter substitution" do
      params = {':username' => 'rtejpar', ':slug' => 'this-is-my-story'}
      uri = Storify::endpoint(params: params, method: :userstory)
      ['rtejpar', 'this-is-my-story'].each {|s| uri.include?(s).should be_true }
    end

    it "should force secure protocol for Authentication" do
      Storify::endpoint(protocol: :secure, method: :auth).include?('https').should be_true
    end

    it "should build the final uri based on dynamic configuration" do
      params = {':username' => 'rtejpar'}
      uri = Storify::endpoint(protocol: :insecure, method: :userstories, params: params)
      uri.should == 'http://api.storify.com/v1/stories/rtejpar'
    end
  end
end
