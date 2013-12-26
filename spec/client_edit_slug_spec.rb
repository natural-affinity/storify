require 'spec_helper'

describe Storify::Client do
  let(:options) { {:version => :v1, :protocol => :insecure} }
  let(:pager) { Storify::Pager.new(page: 1, max: 1, per_page: 10) }
  let(:slug1) { 'getting-started' }
  let(:slug2) { 'storify-is-awesome' }
  let(:tape) { 'edit_slug' }
  let(:client) do
    VCR.use_cassette('auth') do
      Storify::Client.new(:api_key => @api_key, :username => @username).auth(get_password)
    end
  end

  context "#edit_slug [POST /stories/:username/:story-slug/editslug]" do
    it "responds with the new slug name" do
      VCR.use_cassette(tape) do
        expect(client.edit_slug(@username, slug1, slug2)).to eql slug2
        expect(client.edit_slug(@username, slug2, slug1)).to eql slug1
      end
    end

    it "responds with the new slug name using options: version, protocol" do
      VCR.use_cassette(tape, :match_requests_on => vcr_ignore_protocol) do
        expect(client.edit_slug(@username, slug1, slug2, options: options)).to eql slug2
        expect(client.edit_slug(@username, slug2, slug1, options: options)).to eql slug1
      end
    end
  end
end