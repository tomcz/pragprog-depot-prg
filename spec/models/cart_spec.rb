require 'spec_helper'

describe Cart do

  context 'with unique products' do
    before(:each) do
      @book1 = mock_model(Product, :price => 1)
      @book2 = mock_model(Product, :price => 2)
      @cart = Cart.new
      @cart.add_product @book1
      @cart.add_product @book2
    end
    it 'should report two items in cart' do
      @cart.items.size.should == 2
      @cart.total_items.should == 2
    end
    it 'should sum prices of both items in cart' do
      @cart.total_price.should == 3
    end
  end

  context 'with duplicate product' do
    before(:each) do
      @book1 = mock_model(Product, :price => 2)
      @cart = Cart.new
      @cart.add_product @book1
      @cart.add_product @book1
    end
    it 'should contain one item in cart but report two' do
      @cart.items.size.should == 1
      @cart.total_items.should == 2
    end
    it 'should report price x quantity for item in cart' do
      @cart.total_price.should == 4
    end
  end

end
