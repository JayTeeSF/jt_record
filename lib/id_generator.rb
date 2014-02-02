class IdGenerator
  attr_reader :count
  def initialize(count=nil)
    @count = count || 0
  end

  def next
    @count = count + 1
  end
end
