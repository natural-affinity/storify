require 'spec_helper'

describe Storify::Client do
  context "#auth" do
    let(:client) {Storify::Client.new(:api_key => @api_key, :username => @username)}

    it "receives a token on success" do
      VCR.use_cassette('auth', :decode_compressed_response => true) do
        client.auth(get_password)
      end

      expect(client.authenticated).to be_true
    end

    it "raises an API Error on failure" do
      expect(client.authenticated).to be_false

      VCR.use_cassette('auth') do
        expect{client.auth('')}.to raise_error(Storify::ApiError)
      end
    end

    it "accepts endpoint options: version" do
      options = {:version => :v1}

      VCR.use_cassette('auth', :decode_compressed_response => true) do
        client.auth(get_password, options: options)
      end

      expect(client.authenticated).to be_true
    end

    it "ignores endpoint options: protocol, method" do
      options = {:method => :unknown, :protocol => :insecure}

      VCR.use_cassette('auth', :decode_compressed_response => true) do
        client.auth(get_password, options: options)
      end

      expect(client.authenticated).to be_true
    end
  end
end