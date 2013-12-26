require 'spec_helper'

describe Storify::Client do
  let(:client) { Storify::Client.new(:api_key => @api_key, :username => @username) }
  let(:options) { {:version => :v1, :protocol => :insecure} }
  let(:pager) { Storify::Pager.new(page: 1, max: 1, per_page: 5) }
  let(:criteria) { 'startups' }
  let(:tape) { 'search' }

  context "#search [GET /stories/search]" do
    it "gets all stories with search criteria" do
      VCR.use_cassette(tape) do
        expect(client.search(criteria).length).to be > 10
      end
    end

    it "gets all stories with search criteria using options: version, protocol" do
      VCR.use_cassette(tape, :match_requests_on => vcr_ignore_protocol) do
        expect(client.search(criteria, options: options).length).to be > 10
      end
    end

    it "gets the top 5 stories with search criteria" do
      VCR.use_cassette(tape) do
        expect(client.search(criteria, pager: pager).length).to eql 5
      end
    end
  end
end