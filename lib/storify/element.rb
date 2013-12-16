require 'ostruct'
require 'nokogiri'
require 'representable/json'

module Storify
  class Element < OpenStruct

  end

  module ElementRepresentable
    include Representable::JSON

    property :id
    property :eid
    property :type
    property :permalink
    property :posted_at
    property :updated_at
    property :data, :class => Storify::StoryData, :extend => Storify::StoryDataRepresentable
    property :source, :class => Storify::Source, :extend => Storify::SourceRepresentable
    property :attribution, :class => Storify::Attribution, :extend => Storify::AttributionRepresentable
    collection :comments, :class => Storify::Comment, :extend => Storify::CommentRepresentable
    property :stats, :class => Storify::StoryStats, :extend => Storify::StoryStatsRepresentable
    #meta.....highly variable

    def to_s
      out = ''
      desc = ''
      aut = ''
      published = DateTime.parse(posted_at).to_date

      case type
      when 'image'
        desc = data.image.caption
        aut = data.respond_to?(:oembed) ? data.oembed.author_name : attribution.name
      when 'text'
        desc = data.text

        doc = Nokogiri::HTML(desc)
        desc = doc.xpath("//text()").to_s
        desc = desc.gsub(/&[a-z]+;/,'')
      else
        desc = data.send("#{type}".to_sym).description

        aut = source.username
        aut = "@" + aut if source.name.downcase == 'twitter'
      end

      case source.name.downcase
      when 'storify'
        out << "\n#{desc}\n"
        out << ('-' * desc.length) + "\n\n" if desc.length < 40
      when 'twitter'
        out << "[#{published.to_s}] #{aut}: #{permalink}\n"
      else
        out << "#{aut} [#{published.to_s}]: #{permalink}\n"
      end

      out
    end

  end
end