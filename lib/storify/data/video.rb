require 'ostruct'
require 'representable/json'

module Storify
  module Data
    class Video < OpenStruct

    end

    module VideoRepresentable
      include Representable::JSON

      property :src
      property :title
      property :description
      property :thumbnail
    end
  end
end