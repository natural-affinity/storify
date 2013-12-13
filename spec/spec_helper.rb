require 'storify'
require 'io/console'

RSpec.configure do |config|
  config.mock_with :rspec
  config.add_setting :api_key, :default => ''
  config.add_setting :api_usr, :default => ''

  # load user-specific keys or fallback to defaults
  config.before(:all) do
    begin
      require File.dirname(__FILE__) + '/.userkey.rb'
      @api_key = API_KEY
      @username = USERNAME
    rescue LoadError
      @api_key = RSpec.configuration.api_key
      @username = RSpec.configuration.api_usr
    end

  end
end

def get_password
  puts "Enter Storify Password:"
  STDOUT.flush
  STDIN.noecho(&:gets).chomp
end
