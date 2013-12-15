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
      :featured => '/stories/browse/featured',
      :popular => '/stories/browse/popular',
      :topic => '/stories/browse/topic/:topic',
      :search => '/stories/search',
      :editslug => '/stories/:username/:slug/editslug',
      :users => '/users',
      :userprofile => '/users/:username'
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

# base types
require 'storify/features'
require 'storify/dategroup'
require 'storify/coverphoto'
require 'storify/useridentity'
require 'storify/userstats'
require 'storify/agencyinfo'
require 'storify/customerinfokeys'

# settings (user)
require 'storify/settings/fonts'
require 'storify/settings/colors'
require 'storify/settings/options'
require 'storify/settings/notifications'
require 'storify/settings/typekit'
require 'storify/settings/style'

# composite types
require 'storify/usersettings'
require 'storify/customerinfo'
require 'storify/useragency'
require 'storify/user'

