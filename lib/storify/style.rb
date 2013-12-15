require 'ostruct'
require 'representable/json'

module Storify
  class Style < OpenStruct

  end

  module StyleRepresentable
    include Representable::JSON

    property :fonts, :class => Storify::Fonts, :extend => Storify::FontsRepresentable
    property :colors, :class => Storify::Colors, :extend => Storify::ColorsRepresentable
    property :typekit, :class => Storify::Typekit, :extend => Storify::TypekitRepresentable
  end
end