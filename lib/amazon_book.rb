require_relative 'book'
class AmazonBook < Book
  def attributes
    asin
  end
end
