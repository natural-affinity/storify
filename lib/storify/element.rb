require 'date'
require 'nokogiri'

# todo: split logic into separate source types
class Storify::Element
  attr_reader :type, :source, :link, :published, :author
  attr_accessor :desc

  def initialize(content)
    @type = content['type']
    @source = content['source']['name']
    @link = content['permalink']
    @published = DateTime.parse(content['posted_at'])
    
    case @type
    when 'image'
      @desc = content['data'][@type]['caption']
      
      if content['data'].has_key?('oembed')
        @author = content['data']['oembed']['author_name']
      else
        @author = content['attribution']['name']
      end
    when 'text'
      @desc = content['data']['text']

      doc = Nokogiri::HTML(@desc)
      @desc = doc.xpath("//text()").to_s
    else
      @desc = content['data'][@type]['description']
      @author = content['source']['username']
      @author = "@" + @author if @source.downcase == 'twitter'
    end
  end

  def to_s
    out = ''

    case @source.downcase
    when 'storify'
      out << "\n#{@desc}\n"
      out << ('-' * @desc.length) + "\n\n" if @desc.length < 50 
    when 'twitter'
      out << "[#{@published.to_date.to_s}] #{@author}: #{@link}\n"
    else

      out << "#{@author} [#{@published.to_date.to_s}]: #{@link}\n"   
    end

    out
  end
end