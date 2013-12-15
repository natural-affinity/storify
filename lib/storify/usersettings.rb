require 'ostruct'
require 'representable/json'

module Storify
  class UserSettings < OpenStruct

  end

  module UserSettingsRepresentable
    include Representable::JSON

    property :comments
    property :facebook_autoshare
    property :facebook_quoteimg
    property :facebook_post
    property :twitter_post
    property :ban_notify
    property :options, :class => Storify::Options, :extend => Storify::OptionsRepresentable
    property :notifications, :class => Storify::Notifications, :extend => Storify::NotificationsRepresentable
    property :style, :class => Storify::Style, :extend => Storify::StyleRepresentable
  end
end