require 'ostruct'
require 'representable/json'

module Storify
  class Typekit < OpenStruct

  end

  module TypekitRepresentable
    include Representable::JSON

    collection :fonts, :class => Storify::Fonts, :extend => Storify::FontsRepresentable
  end
end