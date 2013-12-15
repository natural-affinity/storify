require 'ostruct'
require 'representable/json'

module Storify
  module Settings
    class Typekit < OpenStruct

    end

    module TypekitRepresentable
      include Representable::JSON

      collection :fonts, :class => Storify::Settings::Fonts, :extend => Storify::Settings::FontsRepresentable
    end
  end
end