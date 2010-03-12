Given /^a user on the index page$/ do
  visit '/store/index'
  #save_and_open_page
end

When /^user adds a product to their shopping cart$/ do
  @product_id = Product.find_products_for_sale.shuffle.first.id
  within "div#product_#{@product_id}" do
    click_button 'Add to Cart'
  end
end

And /^fills in their details on the checkout form$/ do
  @customer_name = UUIDTools::UUID.random_create.to_s
  click_button 'Checkout'
  fill_in 'order_name', :with => @customer_name
  fill_in 'order_address', :with => '9 Evergreen Terrace, Springfield'
  fill_in 'order_email', :with => 'homer@simpson.name'
  select 'Credit Card'
  click_button 'Place Order'
end

Then /^an order is created for the user with a line item corresponding to their selected product$/ do
  response.should have_selector('div#notice', :content => 'Thank you for your order')

  order = Order.find_by_name(@customer_name)
  order.should_not be_nil
  order.line_items.size.should == 1

  line_item = order.line_items.first
  line_item.product.id.should == @product_id
  line_item.quantity.should == 1
end
