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

  def self.stories
    versioned_api << "/stories"
  end

  def self.userstories(username)
    stories << "/#{username}"
  end

  def self.story(username, slug)
    userstories(username) << "/#{slug}"
  end
end

require 'storify/story'
require 'storify/client'
require 'storify/element'
require 'storify/apierror'