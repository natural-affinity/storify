require 'ostruct'
require 'representable/json'

module Storify
  module Data
    class Link < OpenStruct

    end

    module LinkRepresentable
      include Representable::JSON

      property :rest_api_url
      property :oembed_url
      property :thumbnail
      property :description
      property :title
    end
  end
end