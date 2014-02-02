require_relative 'jt_record'
class User
  include JTRecord

  attr_accessible :name, :email

  attr_accessor :books
  def initialize(attrs={})
    @id = attrs.delete(:id)
    @books = attrs.delete(:books) || []
    set_attributes(attrs)
  end

  def has_book? asin
    books.any?{ |user_book| user_book.asin == asin }
  end

  def add_book(book)
    unless has_book? book.asin
      @books << book
      # puts "added #{book.inspect} to me (#{self.inspect}): #{@books.inspect}"
      save
    end
  end
end
