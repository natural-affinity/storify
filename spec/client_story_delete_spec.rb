require 'spec_helper'

describe Storify::Client do
  let(:slug) { 'create-story-test' }
  let(:tape) { 'delete' }
  let(:client) do
    VCR.use_cassette('auth') do
      Storify::Client.new(:api_key => @api_key, :username => @username).auth(get_password)
    end
  end

  context "#delete [POST /stories/:username/:slug/delete]" do
    it "deletes the specified story" do
      VCR.use_cassette(tape) do
        expect(client.delete(slug, @username)).to be_true
      end
    end
  end
end