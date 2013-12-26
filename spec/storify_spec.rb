require 'spec_helper'

describe Storify do
  context "API Protocols" do
    it "supports http" do
      expect(Storify::PROTOCOLS[:insecure]).to eql "http://"
    end

    it "supports secure http" do
      expect(Storify::PROTOCOLS[:secure]).to eql "https://"
    end

    it "defaults to secure http" do
      expect(Storify::PROTOCOLS[:unknown]).to eql "https://"
    end
  end

  context "API Versions" do
    it "supports v1" do
      expect(Storify::ENDPOINTS[:v1].is_a?(Hash)).to be_true
    end

    it "defaults to v1" do
      expect(Storify::ENDPOINTS[:unknown].is_a?(Hash)).to be_true
    end
  end

  context "API Endpoints" do
    it "supports a base URL for a version" do
      expect(Storify::ENDPOINTS[:v1][:base]).to eql "api.storify.com/v1"
    end

    it "defaults to the base URL" do
      expect(Storify::ENDPOINTS[:unknown][:unknown]).to eql "api.storify.com/v1"
    end

    it "supports Authentication" do
      expect(Storify::ENDPOINTS[:v1][:auth]).to eql "/auth"
    end

    it "supports Stories" do
      expect(Storify::ENDPOINTS[:v1][:stories]).to eql "/stories"
    end

    it "supports Latest Stories" do
      expect(Storify::ENDPOINTS[:v1][:latest]).to eql "/stories/browse/latest"
    end

    it "supports Featured Stories" do
      expect(Storify::ENDPOINTS[:v1][:featured]).to eql "/stories/browse/featured"
    end

    it "supports Popular Stories" do
      expect(Storify::ENDPOINTS[:v1][:popular]).to eql "/stories/browse/popular"
    end

    it "supports Stories by Topic" do
      expect(Storify::ENDPOINTS[:v1][:topic]).to eql "/stories/browse/topic/:topic"
    end

    it "supports User Stories" do
      expect(Storify::ENDPOINTS[:v1][:userstories]).to eql "/stories/:username"
    end

    it "supports a Single Story" do
      expect(Storify::ENDPOINTS[:v1][:userstory]).to eql "/stories/:username/:slug"
    end

    it "supports Editing a Story Slug" do
      expect(Storify::ENDPOINTS[:v1][:editslug]).to eql "/stories/:username/:slug/editslug"
    end

    it "supports Searching for Stories" do
      expect(Storify::ENDPOINTS[:v1][:search]).to eql "/stories/search"
    end

    it "supports Users" do
      expect(Storify::ENDPOINTS[:v1][:users]).to eql "/users"
    end

    it "supports User Profiles" do
      expect(Storify::ENDPOINTS[:v1][:userprofile]).to eql "/users/:username"
    end

    it "supports Publishing a Story" do
      expect(Storify::ENDPOINTS[:v1][:publish]).to eql "/stories/:username/:slug/publish"
    end

    it "supports Updating a User Profile" do
      expect(Storify::ENDPOINTS[:v1][:update_profile]).to eql "/users/:username/update"
    end

    it "supports Saving a Story" do
      expect(Storify::ENDPOINTS[:v1][:save]).to eql "/stories/:username/:slug/save"
    end

    it "supports Creating a Story" do
      expect(Storify::ENDPOINTS[:v1][:create]).to eql "/stories/:username/create"
    end

    it "supports Deleting a Story (undocumented)" do
      expect(Storify::ENDPOINTS[:v1][:delete]).to eql "/stories/:username/:slug/delete"
    end
  end

  context "URI Builder" do
    it "allows dynamic protocol selection" do
      expect(Storify::endpoint(protocol: :secure).include?('https')).to be_true
    end

    it "allows dynamic version selection" do
      expect(Storify::endpoint(version: :v1).include?('v1')).to be_true
    end

    it "allows dynamic endpoint selection" do
      expect(Storify::endpoint(method: :auth).include?('/auth')).to be_true
    end

    it "allows dynamic parameter substitution" do
      params = {':username' => 'uname', ':slug' => 'this-is-my-story'}
      uri = Storify::endpoint(params: params, method: :userstory)

      ['uname', 'this-is-my-story'].each do |s|
        expect(uri.include?(s)).to be_true
      end
    end

    it "enforces secure protocol for Authentication" do
      expect(Storify::endpoint(protocol: :secure, method: :auth).include?('https')).to be_true
    end

    it "builds the final uri based on dynamic configuration" do
      params = {':username' => 'uname'}
      expect(Storify::endpoint(protocol: :insecure, method: :userstories, params: params)).to eql 'http://api.storify.com/v1/stories/uname'
    end
  end

  context "API Error Handling" do
    it "returns an empty content block (if api max reached)" do
      eoc = Storify::Client::EOC
      expect(Storify::error(400, '...Max...', 'bad request', end_of_content: eoc)).to eql eoc
    end

    it "raises an API error for a non-max case" do
      eoc = Storify::Client::EOC
      expect{Storify::error(400, '...', 'bad request', end_of_content: eoc)}.to raise_error(Storify::ApiError)
    end
  end
end
