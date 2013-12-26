require 'spec_helper'

describe Storify::Client do
  let(:client) { Storify::Client.new(:api_key => @api_key, :username => @username) }
  let(:options) { {:version => :v1, :protocol => :insecure} }
  let(:pager) { Storify::Pager.new(page: 1, max: 1, per_page: 10) }
  let(:tape) { 'topic' }
  let(:nfl) { 'nfl-playoffs' }

  context "#topic [GET /stories/browse/topic/:topic]" do
    it "gets all stories for a topic" do
      VCR.use_cassette(tape) do
        expect(client.topic(nfl).length).to be > 1
      end
    end

    it "gets all stories for a topic with options: version, protocol" do
      VCR.use_cassette(tape, :match_requests_on => vcr_ignore_protocol) do
        expect(client.topic(nfl, options: options).length).to be > 1
      end
    end

    it "gets the top 10 stories for a topic" do
      VCR.use_cassette(tape) do
        expect(client.topic(nfl, pager: pager).length).to eql 10
      end
    end

    it "raises an exception if the topic is not found" do
      VCR.use_cassette(tape) do
        expect{client.topic('does-not-exist-topic')}.to raise_exception(Storify::ApiError)
      end
    end
  end
end