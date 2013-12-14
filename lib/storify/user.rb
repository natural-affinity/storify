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
    #property :settings, :class => UserSettings, :extend => UserSettingsRepresenter
    property :lang
    #property :stats, :class => UserStats, :extend => UserStatsRepresentable
    property :date, :class => Storify::DateGroup, :extend => Storify::DateGroupRepresentable
    #property :coverPhoto :class => CoverPhoto, :extend => CoverPhotoRepresentable
    property :canFeatureStories
    #collection :featuredStories, :class => ....
    property :paid_plan
    property :email_verified
    #property :features_enabled, :class => Features, :extend => FeaturesRepresentable
    #property :agency, :class => Agency, :extend => AgencyRepresentable
    property :category
    property :is_spam
    collection :subscribers, :class => Storify::User, :extend => Storify::UserRepresentable
    collection :subscriptions, :class => Storify::User, :extend => Storify::UserRepresentable
    collection :identities, :class => Storify::Identity, :extend => Storify::IdentityRepresentable
  end
end