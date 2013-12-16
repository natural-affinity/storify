require 'ostruct'
require 'representable/json'

module Storify
  module Data
    class Oembed < OpenStruct

    end

    module OembedRepresentable
      include Representable::JSON

      property :type
      property :html
      property :thumbnail_url
      property :title
      property :provider_url
      property :provider_name
      property :url
      property :author_url
      property :author_name
    end
  end
end