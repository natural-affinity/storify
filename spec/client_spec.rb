require 'spec_helper'

describe Storify::Client do
  before(:all) do
    @client = Storify::Client.new(@api_key, @username)
    @client.auth(get_password)

    puts "Enter a Story Id for your Account:"
    @story = STDIN.gets.chomp
  end

  it "should get all stories for a specific user" do
    @client.userstories(@username).length.should == 2
  end

  it "should get a specific story for a user (all pages)" do
    @client.story(@story).elements.length.should == 3
  end

  it "should allow a story to be serialized as text" do
    story = @client.story('austin-startup-digest-for-december-9-2014', 'joshuabaer')
    story.should_not eql ""
    puts story.to_s
  end
end
