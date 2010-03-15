class UsersController < ApplicationController

  layout 'admin'

  # GET /users
  # GET /users.xml
  def index
    @users = User.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    respond_to do |format|
      format.html { redirect_to :action => 'form', :id => :new }
      format.xml  { render :xml => User.new }
    end
  end

  # GET /users/1/edit
  def edit
    user = User.find(params[:id])
    conversation = Conversation.create! :ref_id => user.id, :context => 'user'
    redirect_to :action => 'form', :id => conversation
  end

  def form
    @conversation_id = params[:id]
    conversation = Conversation.get_or_create(@conversation_id)
    @user = conversation.setup_instance(User)
    if conversation.ref_id
      render :action => "edit"
    else
      render :action => "new"
    end
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = "User #{@user.name} was successfully created."
        format.html {
          Conversation.delete_if_exists(params[:conversation_id])
          redirect_to :action=>'index'
        }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html {
          conversation = Conversation.get_or_create(params[:conversation_id])
          conversation.update_attributes! :parameters => params[:user], :context => 'user'
          redirect_to :action => 'form', :id => conversation
        }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = "User #{@user.name} was successfully updated."
        format.html {
          Conversation.delete_if_exists(params[:conversation_id])
          redirect_to :action=>'index'
        }
        format.xml  { head :ok }
      else
        format.html {
          conversation = Conversation.get_or_create(params[:conversation_id])
          conversation.update_attributes! :ref_id => @user.id, :parameters => params[:user], :context => 'user'
          redirect_to :action => 'form', :id => conversation
        }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    begin
      @user.destroy
      flash[:notice] = "User #{@user.name} deleted"
    rescue Exception => e
      flash[:notice] = e.message
    end

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

end
