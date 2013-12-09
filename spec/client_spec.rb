require 'spec_helper'

describe Storify::Client do
  before(:all) do
    @client = Storify::Client.new(@api_key, @username)
    @client.auth(get_password)
  end

end
