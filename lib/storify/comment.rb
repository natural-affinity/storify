require 'ostruct'
require 'representable/json'

module Storify
  class Comment < OpenStruct

  end

  module CommentRepresentable
    include Representable::JSON

    property :id
    property :body
    property :date, :class => Storify::DateGroup, :extend => Storify::DateGroupRepresentable
    property :is_spam
    property :author, :class => Storify::User, :extend => Storify::UserRepresentable
    property :canEdit
  end
end