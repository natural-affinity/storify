require 'storify'

RSpec.configure do |config|
  config.mock_with :rspec
  config.add_setting :api_key, :default => nil
  
  config.before(:all) do
    @api_key = RSpec.configuration.api_key
  end
end
