require 'ostruct'
require 'representable/json'

module Storify
  module Agency
    class CustomerInfoKeys < OpenStruct

    end

    module CustomerInfoKeysRepresentable
      include Representable::JSON

      property :approve, :render_nil => true
      property :remove, :render_nil => true
    end
  end
end