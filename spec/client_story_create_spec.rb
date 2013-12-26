require 'spec_helper'

describe Storify::Client do
  let(:options) { {:version => :v1, :protocol => :insecure} }
  let(:story) { Storify::Story.new.extend(Storify::StoryRepresentable) }
  let(:data) { Storify::StoryData.new.extend(Storify::StoryDataRepresentable) }
  let(:tape) { 'create' }
  let(:client) do
    VCR.use_cassette('auth') do
      Storify::Client.new(:api_key => @api_key, :username => @username).auth(get_password)
    end
  end

  context "#create [POST /stories/:username/create]" do
    it "creates a story with multiple elements" do
      VCR.use_cassette(tape) do
        story.title = "Create Story Test"
        story.elements = []
        story.elements << Storify::Element.new.extend(Storify::ElementRepresentable)
        story.elements << Storify::Element.new.extend(Storify::ElementRepresentable)
        story.elements << Storify::Element.new.extend(Storify::ElementRepresentable)

        # add text data item
        item = story.elements[0]
        item.data = Storify::StoryData.new.extend(Storify::StoryDataRepresentable)
        item.data.text = "Start of the story..."

        # add twitter link
        item = story.elements[1]
        item.permalink = "http://twitter.com/fmquaglia/status/409875377482264577"

        # twitter link with image
        item = story.elements[2]
        item.permalink = "http://twitter.com/NicholleJ/status/407924506380861441"

        expect(client.create(story, true)).to_not eql ""
      end
    end
  end
end