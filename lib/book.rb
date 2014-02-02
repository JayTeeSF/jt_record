require_relative 'jt_record'

class Book
  include JTRecord
  attr_accessible :asin, :title, :authors, :details_url

  def self.find_by_asin(asin)
    where(:asin => asin)
  end

  attr_reader :asin
  def initialize(attrs={})
    @id = attrs[:asin]
    fail("must have an asin") unless @id
    set_attributes(attrs)
  end
end
