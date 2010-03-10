require 'spec_helper'

describe Product do

  fixtures :products

  it 'is invalid with empty attributes' do
    product = Product.new
    product.should_not be_valid
    product.should have(1).error_on(:title)
    product.should have(1).error_on(:description)
    product.should have(1).error_on(:price)
    product.should have(2).errors_on(:image_url)
  end

  context 'price validation' do
    before(:each) do
      @product = Product.new(:title => "My Book Title", :description => "yyy", :image_url => "zzz.jpg")
    end
    it 'is invalid with a negative price' do
      @product.price = -1
      @product.should_not be_valid
      @product.errors.on(:price).should == "should be at least 0.01"
    end
    it 'is invalid with zero price' do
      @product.price = 0
      @product.should_not be_valid
      @product.errors.on(:price).should == "should be at least 0.01"
    end
    it 'is valid with a positive price' do
      @product.price = 1
      @product.should be_valid
    end
  end

  context 'image url validation' do
    before(:each) do
      @product = Product.new(:title => "My Book Title", :description => "yyy", :price => 1)
    end
    it 'is valid with known image extension' do
      ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
      ok.each do |url|
        @product.image_url = url
        @product.should be_valid
        @product.should have(:no).errors_on(:image_url)
      end
    end
    it 'is invalid with unknown image extension' do
      bad = %w{ fred.doc fred.gif/more fred.gif.more }
      bad.each do |url|
        @product.image_url = url
        @product.should_not be_valid
        @product.should have(1).error_on(:image_url)
      end
    end
  end

  context 'title validation' do
    it 'validates that the title is unique' do
      title = products(:ruby_book).title
      product = Product.new(:title => title, :description => "yyy", :price => 1, :image_url => "fred.gif")
      product.should_not be_valid
      product.should have(1).error_on(:title)
      product.errors_on(:title).should == ['has already been taken']
    end
  end

end
