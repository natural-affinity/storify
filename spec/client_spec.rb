require 'spec_helper'

describe Storify::Client do
  let(:key) { 'k' }
  let(:usr) { 'u' }
  let(:tok) { 't' }

  context ".new" do
    it "accepts a hash of credentials as symbols" do
      client = Storify::Client.new(:api_key => key, :username => usr, :token => tok)
      expect(client.api_key).to eql key
      expect(client.username).to eql usr
      expect(client.token).to eql tok
    end

    it "accepts a hash of credentials as strings" do
      client = Storify::Client.new('api_key' => key, 'username' => usr, 'token' => tok)
      expect(client.api_key).to eql key
      expect(client.username).to eql usr
      expect(client.token).to eql tok
    end

    it "accepts a block of credentials" do
      client = Storify::Client.new do |config|
        config.api_key = key
        config.username = usr
        config.token = tok
      end

      expect(client.api_key).to eql key
      expect(client.username).to eql usr
      expect(client.token).to eql tok
    end

    it "raises an exception for unknown hash credentials" do
      expect {Storify::Client.new(:unknown => 'value')}.to raise_exception
    end

    it "raises an exception for unknown block credentials" do
      expect {Storify::Client.new {|config| config.unknown = ''}}.to raise_exception
    end
  end
end
