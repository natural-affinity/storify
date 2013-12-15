require 'ostruct'
require 'representable/json'

module Storify
  class Colors < OpenStruct

  end

  module ColorsRepresentable
    include Representable::JSON

    property :text
    property :link
    property :background
  end
end