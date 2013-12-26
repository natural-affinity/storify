require 'spec_helper'

describe Storify::Client do
  let(:client) { Storify::Client.new(:api_key => @api_key, :username => @username) }
  let(:options) { {:version => :v1, :protocol => :insecure} }
  let(:pager) { Storify::Pager.new(page: 1, max: 1, per_page: 20) }
  let(:tape) { 'latest' }

  context "#latest [GET /stories/browse/latest]" do
    it "gets all latest stories" do
      VCR.use_cassette(tape) do
        expect(client.latest.length).to be > 400
      end
    end

    it "gets all latest stories with options: version, protocol" do
      VCR.use_cassette(tape, :match_requests_on => vcr_ignore_protocol) do
        expect(client.latest(options: options).length).to be > 400
      end
    end

    it "gets the top 20 latest stories" do
      VCR.use_cassette(tape) do
        expect(client.latest(pager: pager).length).to eql 20
      end
    end
  end
end