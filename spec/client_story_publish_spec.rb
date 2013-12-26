require 'spec_helper'

describe Storify::Client do
  let(:options) { {:version => :v1, :protocol => :insecure} }
  let(:story) { Storify::Story.new.extend(Storify::StoryRepresentable) }
  let(:user) { Storify::User.new.extend(Storify::UserRepresentable) }
  let(:desc) { 'This is a desc modification test' }
  let(:tape) { 'publish' }
  let(:client) do
    VCR.use_cassette('auth') do
      Storify::Client.new(:api_key => @api_key, :username => @username).auth(get_password)
    end
  end
  let(:test_story) do
    VCR.use_cassette('story') do
      client.story('test-story', @username)
    end
  end
  let(:empty_story) do
    VCR.use_cassette('story') do
      client.story('no-embeds')
    end
  end

  context "#publish [POST /stories/:username/:slug/publish]" do
    it "raises an exception if a story is not provided" do
      VCR.use_cassette(tape) do
        expect{client.publish(nil)}.to raise_exception
      end
    end

    it "raises an exception if the story is not found" do
      user.username = @username
      story.author = user
      story.slug = 'does-not-exist-story'

      VCR.use_cassette(tape) do
        expect{client.publish(story)}.to raise_exception(Storify::ApiError)
      end
    end

    it "raises an exception if unauthorized" do
      user.username = 'storify'
      story.author = user
      story.slug = 'storify-acquired-by-livefyre'

      VCR.use_cassette(tape) do
        expect{client.publish(story)}.to raise_exception(Storify::ApiError)
      end
    end

    it "publishes an existing story" do
      VCR.use_cassette(tape) do
        expect(client.publish(test_story)).to be_true
      end
    end

    it "publishes an existing story using options: version, protocol" do
      VCR.use_cassette(tape, :match_requests_on => vcr_ignore_protocol) do
        expect(client.publish(test_story, options: options)).to be_true
      end
    end

    it "should allow changes to the story during a publish" do
      expect(empty_story.description).to_not eql desc
      empty_story.description = desc

      VCR.use_cassette(tape) do
        expect(client.publish(empty_story)).to be_true
        expect(client.story('no-embeds', @username).description).to eql desc
      end
    end
  end
end