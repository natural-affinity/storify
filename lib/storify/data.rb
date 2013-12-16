require 'ostruct'
require 'representable/json'

module Storify
  class StoryData < OpenStruct

  end

  module StoryDataRepresentable
    include Representable::JSON

    property :image, :class => Storify::Data::Image, :extend => Storify::Data::ImageRepresentable
    property :oembed, :class => Storify::Data::Oembed, :extend => Storify::Data::OembedRepresentable
    property :link, :class => Storify::Data::Link, :extend => Storify::Data::LinkRepresentable
    property :video, :class => Storify::Data::Video, :extend => Storify::Data::VideoRepresentable
    property :text
  end
end