class StoreController < ApplicationController

  before_filter :load_cart, :except => [:empty_cart]
  before_filter :cart_is_not_empty, :only => [:new_order, :checkout, :save_order]

  def index
    @products = Product.find_products_for_sale
  end

  def add_to_cart
    product = Product.find(params[:id])
    @current_item = @cart.add_product(product)
    respond_to do |format|
      format.js if request.xhr?
      format.html {redirect_to_index}
    end
  rescue ActiveRecord::RecordNotFound
    logger.error("Attempt to access invalid product #{params[:id]}")
    redirect_to_index "Invalid product"
  end

  def empty_cart
    session[:cart] = nil
    redirect_to_index
  end

  def new_order
    redirect_to :action => 'checkout', :id => :new
  end

  def checkout
    @conversation_id = params[:id]
    conversation = Conversation.get_or_create(@conversation_id)
    @order = conversation.setup_instance(Order)
  end

  def save_order
    @order = Order.new(params[:order])
    @order.add_line_items_from_cart(@cart)
    if @order.save
      session[:cart] = nil
      Conversation.delete_if_exists(params[:id])
      redirect_to_index("Thank you for your order")
    else
      conversation = Conversation.get_or_create(params[:id])
      conversation.update_attributes! :parameters => params[:order], :context => 'order'
      redirect_to :action => 'checkout', :id => conversation
    end
  end

  protected

  def load_cart
    @cart = session[:cart] ||= Cart.new
  end

  def cart_is_not_empty
    if @cart.items.empty?
      redirect_to_index("Your cart is empty")
    end
  end

  def authorize
    # don't protect the store with a login
  end

  private

  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => 'index'
  end

end
