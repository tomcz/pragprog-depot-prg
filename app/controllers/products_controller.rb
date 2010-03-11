class ProductsController < ApplicationController

  layout 'admin'

  # GET /products
  # GET /products.xml
  def index
    @products = Product.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @products }
    end
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @product }
    end
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    respond_to do |format|
      format.html { redirect_to :action => 'form', :id => :new }
      format.xml { render :xml => Product.new }
    end
  end

  # GET /products/1/edit
  def edit
    product = Product.find(params[:id])
    conversation = Conversation.create! :ref_id => product.id, :context => 'product'
    redirect_to :action => 'form', :id => conversation
  end

  def form
    @conversation_id = params[:id]
    conversation = Conversation.get_or_create(@conversation_id)
    @product = conversation.setup_instance(Product)
    if conversation.ref_id
      render :action => "edit"
    else
      render :action => "new"
    end
  end

  # POST /products
  # POST /products.xml
  def create
    product = Product.new(params[:product])

    respond_to do |format|
      if product.save
        flash[:notice] = 'Product was successfully created.'
        format.html {
          Conversation.destroy_if_exists(params[:conversation_id])
          redirect_to(product)
        }
        format.xml { render :xml => product, :status => :created, :location => product }
      else
        format.html {
          conversation = Conversation.get_or_create(params[:conversation_id])
          conversation.update_attributes! :parameters => params[:product], :context => 'product'
          redirect_to :action => 'form', :id => conversation
        }
        format.xml { render :xml => product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
    product = Product.find(params[:id])

    respond_to do |format|
      if product.update_attributes(params[:product])
        flash[:notice] = 'Product was successfully updated.'
        format.html {
          Conversation.destroy_if_exists(params[:conversation_id])
          redirect_to(product)
        }
        format.xml { head :ok }
      else
        format.html {
          conversation = Conversation.get_or_create(params[:conversation_id])
          conversation.update_attributes! :ref_id => product.id, :parameters => params[:product], :context => 'product'
          redirect_to :action => 'form', :id => conversation
        }
        format.xml { render :xml => product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    Product.destroy(params[:id])

    respond_to do |format|
      format.html { redirect_to(products_url) }
      format.xml { head :ok }
    end
  end

end
