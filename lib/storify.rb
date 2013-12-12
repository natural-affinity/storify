module Storify
  PROTOCOLS = {
    :secure => 'https://',
    :insecure => 'http://'
  }

  ENDPOINTS = {
    :v1 => {
      :base => 'api.storify.com/v1',
      :auth => '/auth',
      :stories => '/stories',
      :userstories => '/stories/:username',
      :userstory => '/stories/:username/:slug',
      :latest => '/stories/browse/latest',
      :featured => '/stories/browse/featured'
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

  def self.error(code, message, type, end_of_content: {})
    unless message.downcase.include?('max')
      raise Storify::ApiError.new(code, message, type)
    end

    end_of_content
  end
end

require 'storify/story'
require 'storify/client'
require 'storify/pager'
require 'storify/element'
require 'storify/apierror'
