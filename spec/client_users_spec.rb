require 'spec_helper'

describe Storify::Client do
  let(:client) { Storify::Client.new(:api_key => @api_key, :username => @username) }
  let(:options) { {:version => :v1, :protocol => :insecure} }
  let(:pager) { Storify::Pager.new(page: 1, max: 1, per_page: 10) }
  let(:tape) { 'users' }

  context "#users [GET /users]" do
    it "gets all users" do
      VCR.use_cassette(tape) do
        expect(client.users.length).to be > 100
      end
    end

    it "gets all users using options: version, protocol" do
      VCR.use_cassette(tape, :match_requests_on => vcr_ignore_protocol) do
        expect(client.users(options: options).length).to be > 100
      end
    end

    it "gets the first 10 users" do
      VCR.use_cassette(tape) do
        expect(client.users(pager: pager).length).to eql 10
      end
    end
  end
end