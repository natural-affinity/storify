require 'ostruct'
require 'representable/json'

module Storify
  module Data
    class Image < OpenStruct

    end

    module ImageRepresentable
      include Representable::JSON

      property :src
      property :caption
      property :thumbnail
    end
  end
end