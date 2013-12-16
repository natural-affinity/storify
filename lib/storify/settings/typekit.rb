require 'ostruct'
require 'representable/json'

module Storify
  module Settings
    class Typekit < OpenStruct

    end

    module TypekitRepresentable
      include Representable::JSON

      property :kitId
    end
  end
end