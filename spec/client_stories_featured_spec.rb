require 'spec_helper'

describe Storify::Client do
  let(:client) { Storify::Client.new(:api_key => @api_key, :username => @username) }
  let(:options) { {:version => :v1, :protocol => :insecure} }
  let(:pager) { Storify::Pager.new(page: 1, max: 1, per_page: 20) }
  let(:tape) { 'featured' }

  context "#featured [GET /stories/browse/featured]" do
    it "gets all featured stories" do
      VCR.use_cassette(tape) do
        expect(client.featured.length).to be > 400
      end
    end

    it "gets all featured stories with options: version, protocol" do
      VCR.use_cassette(tape, :match_requests_on => vcr_ignore_protocol) do
        expect(client.featured(options: options).length).to be > 400
      end
    end

    it "gets the top 20 featured stories" do
      VCR.use_cassette(tape) do
        expect(client.featured(pager: pager).length).to eql 20
      end
    end
  end
end