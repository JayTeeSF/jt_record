require_relative '../../lib/books_controller'
require_relative '../../lib/user'
describe BooksController do
  def post method_name, params={}
    BooksController.send(method_name, params, user.id)
  end
  def user
    unless @user
      @user = User.create!
    end
    @user
  end

  before(:each) {
    Book.destroy_all
    User.destroy_all
  }

  context "when there is an ASIN" do
    let(:asin) { "the-asin" }
    let(:book_attributes) do
      {
        :asin => asin,
        :title => "H",
        :authors => "WS",
        :details_url => "http://example.com/hamlet"
      }
    end
    context "when the book is in the database" do
      let!(:book) { Book.create!(book_attributes) }

      it "adds the book to the user" do
        post :create, :id => asin
        user.books.should == [book]
      end

      it "does not add the book to the user if (s)he already has it" do
        user.books << book
        post :create, :id => asin
        user.books.should == [book]
      end
    end

    context "when the book is not in the database" do
      it "adds the book to the user using Amazon data" do
        amazon_book = double(:attributes => book_attributes)
        AmazonBook.stub(:find_by_asin).with(asin) { amazon_book }
        post :create, :id => asin
      end

      it "does not add the book to the user if Amazon does not have it" do
        AmazonBook.stub(:find_by_asin).with(asin) { nil }
        post :create, :id => asin
        user.books.should be_empty
      end
    end
  end

  context "when there is not an ASIN" do
    it "does not add the book to the user" do
      post :create, :id => nil
      user.books.should be_empty
    end
  end
end
