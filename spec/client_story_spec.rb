require 'spec_helper'

describe Storify::Client do
  let(:options) { {:version => :v1, :protocol => :insecure} }
  let(:pager) { Storify::Pager.new(page: 2, max: 3) }
  let(:digest) { 'austin-startup-digest-for-december-9-2014' }
  let(:slug) { 'test-story' }
  let(:tape) { 'story' }
  let(:client) do
    VCR.use_cassette('auth') do
      Storify::Client.new(:api_key => @api_key, :username => @username).auth(get_password)
    end
  end

  context "#story [GET /stories/:username/:slug]" do
    it "gets an entire story for a user" do
      VCR.use_cassette(tape) do
        expect(client.story(slug).elements.length).to eql 3
      end
    end

    it "gets an entire story for a user using options: version, protocol" do
      VCR.use_cassette(tape, :match_requests_on => vcr_ignore_protocol) do
        expect(client.story(slug, options: options).elements.length).to eql 3
      end
    end

    it "gets specific pages of a story for a user" do
      VCR.use_cassette(tape) do
        story = client.story(digest, 'joshuabaer', pager: pager).to_s

        ['408651138632667136', '409182832234213376'].each do |s|
          expect(story.include?(s)).to be_true
        end
      end
    end
  end

  context "#to_s" do
    it "serializes a story as text" do
      VCR.use_cassette(tape) do
        expect(client.story(digest, 'joshuabaer').to_s).to_not eql ""
      end
    end
  end
end