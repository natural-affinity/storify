require 'ostruct'
require 'representable/json'

module Storify
  module Settings
    class Fonts < OpenStruct

    end

    module FontsRepresentable
      include Representable::JSON

      property :title
      property :body
    end
  end
end