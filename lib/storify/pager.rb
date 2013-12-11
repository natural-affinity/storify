class Storify::Pager
  MIN_PAGE = 1
  MAX_PER_PAGE = 50

  attr_reader :page, :per_page, :max

  def initialize(page: 1, per_page: 20, max: 0)
    @max = max.to_i.abs
    self.page=(page)
    self.per_page=(per_page)
  end

  def per_page=(value)
    @per_page = (value > MAX_PER_PAGE) ? MAX_PER_PAGE : value.to_i.abs
  end

  def next
    self.page=(@page + 1)
    self
  end

  def prev
    self.page=(@page - 1)
    self
  end

  def to_hash
    {:page => @page, :per_page => @per_page}
  end

  def has_pages?(array = [])
    return false unless array.is_a?(Array)
    return false if (@page > @max && @max != 0)

    array.length != 0
  end

  private

  def page=(value)
    return @page = MIN_PAGE if (value < MIN_PAGE)
    return @page = (@max + 1) if ((value > @max) && @max != 0)

    @page = value.to_i
  end
end