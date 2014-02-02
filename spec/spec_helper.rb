require 'webmock/rspec'
require 'coveralls'
require 'storify'
require 'vcr'
require 'uri'

ENV['STORIFY_TOKEN'] = "mock__token"
ENV['STORIFY_SECRET'] = "mock_secret"
ENV['STORIFY_EMAIL'] = "mock_email"
ENV['STORIFY_TOK'] = "mock_token"
ENV['STORIFY_PASSWORD'] = "mock_password"
ENV['STORIFY_USERNAME'] = "rtejpar"
ENV['STORIFY_APIKEY'] = "mock_apikey"

Coveralls.wear!

RSpec.configure do |config|
  config.before(:all) do
    @api_key = ENV['STORIFY_APIKEY']
    @username = ENV['STORIFY_USERNAME']
  end
end

def get_password
  ENV['STORIFY_PASSWORD']
end

def get_encoded_password
  URI.encode_www_form_component(get_password)
end

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('mock__token') {ENV['STORIFY_TOKEN']}
  config.filter_sensitive_data('mock_secret') {ENV['STORIFY_SECRET']}
  config.filter_sensitive_data('mock_token') {ENV['STORIFY_TOK']}
  config.filter_sensitive_data('mock_username') {ENV['STORIFY_USERNAME']}
  config.filter_sensitive_data('mock_apikey') {ENV['STORIFY_APIKEY']}
  config.filter_sensitive_data('mock_email') {ENV['STORIFY_EMAIL']}

  config.filter_sensitive_data('mock_password') do |interaction|
    get_encoded_password
  end

  config.default_cassette_options = { :record => :new_episodes, :match_requests_on => [:query, :uri, :method, :body] }
end

def vcr_ignore_protocol
  [:host, :path, :method, :query, :body]
end
