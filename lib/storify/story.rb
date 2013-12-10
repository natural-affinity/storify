require 'date'

class Storify::Story
  attr_reader :slug, :title, :desc, :link, :published, :author, :elements

  def initialize(content)
    @slug = content['slug']
    @title = content['title']
    @desc = content['description']
    @link = content['permalink']
    @author = content['author']['username']

    unless content['date']['published'].nil?
      @published = DateTime.parse(content['date']['published'])
    end

    @elements = []
  end

  def add_element(element)
    @elements << element
  end

  def to_s
    published = @published.nil? ? 'unpublished' : @published.to_date.to_s

    out = "\n#{@title}\n"
    out << ('-' * @title.length.to_i) + "\n"
    out << "Date: #{published}\n"
    out << "Author: #{@author}\n"
    out << "Link: #{@link}\n"
    out << "\n#{@desc} \n"

    # serialize elements
    elements.each {|e| out << e.to_s }

    out
  end
end