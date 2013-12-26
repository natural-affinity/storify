require 'spec_helper'

describe Storify::Client do
  let(:options) { {:version => :v1, :protocol => :insecure} }
  let(:element) { Storify::Element.new.extend(Storify::ElementRepresentable) }
  let(:data) { Storify::StoryData.new.extend(Storify::StoryDataRepresentable) }
  let(:tape) { 'save' }
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

  context "#save [POST /stories/:username/:slug/save]" do
    it "saves an existing story" do
      element.data = data
      element.data.text = "Added new text item"
      empty_story.elements << element

      VCR.use_cassette(tape) do
        expect(client.save(empty_story)).to be_true
        expect(client.publish(empty_story)).to be_true

        revised = client.story('no-embeds', @username)
        expect(revised.elements.length).to eql 1

        revised.elements = []
        expect(client.save(revised)).to be_true
        expect(client.publish(revised)).to be_true
      end
    end
  end
end