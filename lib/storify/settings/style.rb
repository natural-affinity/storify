require 'ostruct'
require 'representable/json'

module Storify
  module Settings
    class Style < OpenStruct

    end

    module StyleRepresentable
      include Representable::JSON

      property :fonts, :class => Storify::Settings::Fonts, :extend => Storify::Settings::FontsRepresentable
      property :colors, :class => Storify::Settings::Colors, :extend => Storify::Settings::ColorsRepresentable
      property :typekit, :class => Storify::Settings::Typekit, :extend => Storify::Settings::TypekitRepresentable
    end
  end
end