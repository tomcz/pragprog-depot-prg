class Order < ActiveRecord::Base

  set_primary_key :uuid
  include UUIDHelper

  has_many :line_items

  PAYMENT_TYPES = [['Credit Card', 'cc'], ['PayPal', 'pp']]

  validates_presence_of :name, :address, :email, :pay_type
  validates_inclusion_of :pay_type, :in => PAYMENT_TYPES.map {|disp, value| value}

  def add_line_items_from_cart(cart)
    cart.items.each do |item|
      li = LineItem.from_cart_item(item)
      self.line_items << li
    end
  end

  def payment_type
    PAYMENT_TYPES.select{|disp, value| value == self.pay_type}.map{|disp, value| disp}.first
  end

  def total_price
    self.line_items.map{|item| item.total_price}.sum
  end

  def total_items
    self.line_items.map{|item| item.quantity}.sum
  end

end
