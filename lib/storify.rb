module Storify
  BASE_URL = 'https://api.storify.com'

  def self.api(secure = true)
    (secure ? 'https' : 'http') + '://api.storify.com'
  end

  def self.versioned_api(secure: true, version: 1)
    api(secure) << "/v#{version}"
  end

  def self.auth
    versioned_api << "/auth"
  end
end

require 'storify/client'
require 'storify/apierror'