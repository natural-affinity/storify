require 'ostruct'
require 'representable/json'

module Storify
  class CoverPhoto < OpenStruct

  end

  module CoverPhotoRepresentable
    include Representable::JSON

    property :url
    property :width
    property :height
  end
end