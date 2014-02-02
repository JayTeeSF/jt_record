require_relative 'user'
require_relative 'amazon_book'
require_relative 'book'
class BooksController
  def self.create(params={}, *args)
    new(params, *args).create
  end

  attr_reader :params, :current_user
  def initialize( params={:id => 1}, current_user_id=nil )
    @params = params
    @current_user = current_user_id ? User.where(:id => current_user_id) : User.new
  end

  def create
    @asin = params[:id]

    if @asin.present?
      @book = Book.find_by_asin(@asin)

      # puts "unpresent book: #{@book.inspect}"
      unless @book.present?
        amazon_book = AmazonBook.find_by_asin(@asin)
        if amazon_book.present?
          @book = Book.new(amazon_book.attributes)
        end
      end

      if @book.present?
          # puts "book present ...should add"
          current_user.add_book(@book)
      else
        # puts "book (#{@book.inspect}) not present"
      end
    end

    puts "rendering @book"
  end
end
