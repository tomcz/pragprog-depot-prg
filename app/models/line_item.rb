class LineItem < ActiveRecord::Base

  set_primary_key :uuid
  include UUIDHelper

  belongs_to :order
  belongs_to :product

  def self.from_cart_item(cart_item)
    li = self.new
    li.product = cart_item.product
    li.quantity = cart_item.quantity
    li.total_price = cart_item.price
    li
  end

end
