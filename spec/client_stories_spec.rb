require 'spec_helper'

describe Storify::Client do
  let(:client) { Storify::Client.new(:api_key => @api_key, :username => @username) }
  let(:options) { {:version => :v1, :protocol => :insecure} }
  let(:pager) { Storify::Pager.new(page: 1, max: 2, per_page: 20) }
  let(:tape) { 'stories' }

  context "#stories [GET /stories]" do
    it "gets all stories" do
      VCR.use_cassette(tape) do
        expect(client.stories.length).to be > 400
      end
    end

    it "gets all stories with options: version, protocol" do
      VCR.use_cassette(tape, :match_requests_on => vcr_ignore_protocol) do
        expect(client.stories(options: options).length).to be > 400
      end
    end

    it "gets the first 2 pages of stories" do
      VCR.use_cassette(tape) do
        expect(client.stories(pager: pager).length).to eql 40
      end
    end
  end
end