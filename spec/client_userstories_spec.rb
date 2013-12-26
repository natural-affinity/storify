require 'spec_helper'

describe Storify::Client do
  let(:options) { {:version => :v1, :protocol => :insecure} }
  let(:pager) { Storify::Pager.new(page: 1, max: 1, per_page: 10) }
  let(:tape) { 'userstories' }
  let(:client) do
    VCR.use_cassette('auth') do
      Storify::Client.new(:api_key => @api_key, :username => @username).auth(get_password)
    end
  end

  context "#userstories [GET /stories/:username]" do
    it "gets all stories for a user" do
      VCR.use_cassette(tape) do
        expect(client.userstories.length).to be >= 2
      end
    end

    it "gets all stories for a user using options: version, protocol" do
      VCR.use_cassette(tape, :match_requests_on => vcr_ignore_protocol) do
        expect(client.userstories(options: options).length).to be >= 2
      end
    end

    it "gets the first page of stories for a user" do
      VCR.use_cassette(tape) do
        expect(client.userstories('joshuabaer', pager: pager).length).to eql 10
      end
    end
  end
end