require 'ostruct'
require 'representable/json'

module Storify
  class Notifications < OpenStruct

  end

  module NotificationsRepresentable
    include Representable::JSON

    property :newsletter
    property :digest
    property :likes
    property :comments
    property :follower
    property :quoted
    property :friend_quoted
    property :autoshare
    property :element_comment
    property :element_like
    property :story_comment
    property :story_like
  end
end