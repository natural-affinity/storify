module Storify
  PROTOCOLS = {
    :secure => 'https://',
    :insecure => 'http://'
  }

  ENDPOINTS = {
    :v1 => {
      :base => 'api.storify.com/v1',
      :auth => '/auth',
      :userstories => '/stories/:username',
      :userstory => '/stories/:username/:slug'
    }
  }

  # Set protocol and endpoint defaults
  PROTOCOLS.default = PROTOCOLS[:secure]
  ENDPOINTS.default = ENDPOINTS[:v1]
  ENDPOINTS[:v1].default = ENDPOINTS[:v1][:base]

  def self.endpoint(version: :v1, protocol: :secure, method: :base, params: {})
    uri = (method == :auth) ? PROTOCOLS[:secure] : PROTOCOLS[protocol]
    uri += ENDPOINTS[version][:base]
    uri += ENDPOINTS[version][method]
    params.each_pair {|k,v| uri = uri.gsub(k,v) }

    uri
  end
end

require 'storify/story'
require 'storify/client'
require 'storify/element'
require 'storify/apierror'