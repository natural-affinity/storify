require 'ostruct'
require 'representable/json'

module Storify
  class User < OpenStruct

  end

  module UserRepresentable
    include Representable::JSON

    property :_id
    property :username
    property :_access
    property :name
    property :bio
    property :location
    property :website
    property :avatar
    property :permalink
    property :settings, :class => Storify::UserSettings, :extend => Storify::UserSettingsRepresentable
    property :lang
    property :stats, :class => Storify::UserStats, :extend => Storify::UserStatsRepresentable
    property :date, :class => Storify::DateGroup, :extend => Storify::DateGroupRepresentable
    property :coverPhoto, :class => Storify::CoverPhoto, :extend => Storify::CoverPhotoRepresentable
    property :canFeatureStories
    collection :featuredStories
    property :paid_plan
    property :email_verified
    property :features_enabled, :class => Storify::Features, :extend => Storify::FeaturesRepresentable
    property :agency, :class => Storify::UserAgency, :extend => Storify::UserAgencyRepresentable
    property :category
    property :is_spam
    collection :subscribers, :class => Storify::User, :extend => Storify::UserRepresentable
    collection :subscriptions, :class => Storify::User, :extend => Storify::UserRepresentable
    collection :identities, :class => Storify::UserIdentity, :extend => Storify::UserIdentityRepresentable
  end
end