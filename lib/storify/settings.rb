require 'ostruct'
require 'representable/json'

module Storify
  class UserSettings < OpenStruct

  end

  module UserSettingsRepresentable
    include Representable::JSON

    property :sxsw
    property :comments
    property :facebook_autoshare
    property :facebook_quoteimg
    property :facebook_post
    property :twitter_post
    property :ban_notify
    property :options, :class => Storify::Settings::Options, :extend => Storify::Settings::OptionsRepresentable
    property :notifications, :class => Storify::Settings::Notifications, :extend => Storify::Settings::NotificationsRepresentable
    property :style, :class => Storify::Settings::Style, :extend => Storify::Settings::StyleRepresentable
  end
end