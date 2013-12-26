require 'spec_helper'

describe Storify::Client do
  let(:options) { {:version => :v1, :protocol => :insecure} }
  let(:user) { Storify::User.new.extend(Storify::UserRepresentable) }
  let(:not_found) { 'mock_user$$$$' }
  let(:tape) { 'profile_update' }
  let(:rloc) { "This is a new location" }
  let(:client) do
    VCR.use_cassette('auth') do
      Storify::Client.new(:api_key => @api_key, :username => @username).auth(get_password)
    end
  end

  context "#update_profile [POST /users/:username/update]" do
    it "raises an exception if a user is not provided" do
      VCR.use_cassette(tape) do
        expect{client.update_profile(nil)}.to raise_exception
      end
    end

    it "raises an exception if the user is not found" do
      VCR.use_cassette(tape) do
        user.username = not_found
        expect{client.update_profile(user)}.to raise_exception(Storify::ApiError)
      end
    end

    it "raises an exception if the user is not found using options" do
      VCR.use_cassette(tape, :match_requests_on => vcr_ignore_protocol) do
        user.username = not_found
        expect{client.update_profile(user, options: options)}.to raise_exception(Storify::ApiError)
      end
    end

    it "raises an exception if the profile cannot be updated" do
      VCR.use_cassette(tape) do
        user.username = "storify"
        expect{client.update_profile(user)}.to raise_exception(Storify::ApiError)
      end
    end

    it "rejects profile updates for free plans" do
      u = nil

      VCR.use_cassette('profile') do
        u = client.profile(@username)
        u.location = rloc
      end

      VCR.use_cassette(tape) do
        expect(u.paid_plan).to eql "free"
        expect{client.update_profile(u)}.to raise_exception(Storify::ApiError)
      end
    end
  end
end