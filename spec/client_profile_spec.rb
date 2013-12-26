require 'spec_helper'

describe Storify::Client do
  let(:options) { {:version => :v1, :protocol => :insecure} }
  let(:tape) { 'profile' }
  let(:client) do
    VCR.use_cassette('auth') do
      Storify::Client.new(:api_key => @api_key, :username => @username).auth(get_password)
    end
  end

  context "#profile [GET /users/:username]" do
    it "gets a user profile" do
      VCR.use_cassette(tape) do
        expect(client.profile(@username).username).to eql @username
      end
    end
  end
end