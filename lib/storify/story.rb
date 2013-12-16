require 'ostruct'
require 'date'
require 'representable/json'

module Storify
  class Story < OpenStruct

  end

  module StoryRepresentable
    include Representable::JSON

    property :sid
    property :title
    property :slug
    property :status
    property :version
    property :permalink
    property :shortlink
    property :description
    property :thumbnail
    property :date, :class => Storify::DateGroup, :extend => Storify::DateGroupRepresentable
    property :private
    property :not_indexed
    property :is_spam
    collection :topics
    collection :siteposts
    property :meta, :class => Storify::StoryMeta, :extend => Storify::StoryMetaRepresentable
    property :stats, :class => Storify::StoryStats, :extend => Storify::StoryStatsRepresentable
    property :modified
    property :deleted
    property :author, :class => Storify::User, :extend => Storify::UserRepresentable
    property :canEdit
    collection :comments, :class => Storify::Comment, :extend => Storify::CommentRepresentable
    collection :elements, :class => Storify::Element, :extend => Storify::ElementRepresentable

    def to_s
      published = DateTime.parse(date.published)
      published = published.nil? ? 'unpublished' : published.to_date

      out = "\n#{title}\n"
      out << ('-' * title.length.to_i) + "\n"
      out << "Date: #{published.to_s}\n"
      out << "Author: #{author.name}\n"
      out << "Link: #{permalink}\n"
      out << "\n#{description} \n"

      # serialize elements
      elements.each {|e| out << e.to_s }

      out
    end
  end
end