require 'ostruct'
require 'representable/json'

module Storify
  class Features < OpenStruct

  end

  module FeaturesRepresentable
    include Representable::JSON

    property :custom_embed_style
    property :private_stories
    property :html_for_seo
    property :no_advertising
    property :business_options
    property :headerless_embed
    property :pdf
    property :realtime_updates
    property :storylock
    property :maxEditors
  end
end