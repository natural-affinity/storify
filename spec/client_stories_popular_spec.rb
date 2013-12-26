require 'spec_helper'

describe Storify::Client do
  let(:client) { Storify::Client.new(:api_key => @api_key, :username => @username) }
  let(:options) { {:version => :v1, :protocol => :insecure} }
  let(:pager) { Storify::Pager.new(page: 1, max: 1, per_page: 15) }
  let(:tape) { 'popular' }

  context "#popular [GET /stories/browse/popular]" do
    it "gets all popular stories" do
      VCR.use_cassette(tape) do
        expect(client.popular.length).to be > 400
      end
    end

    it "gets all popular stories with options: version, protocol" do
      VCR.use_cassette(tape, :match_requests_on => vcr_ignore_protocol) do
        expect(client.popular(options: options).length).to be > 400
      end
    end

    it "gets the top 15 popular stories" do
      VCR.use_cassette(tape) do
        expect(client.popular(pager: pager).length).to eql 15
      end
    end
  end
end