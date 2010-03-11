require 'spec_helper'

describe AdminController do

  context 'not logged in' do
    it 'should redirect to login when asked for index page' do
      get :index
      response.should redirect_to(:controller => 'admin', :action => 'login')
    end
  end

  context 'logged in as administrator' do
    it 'should render index page'do
      User.should_receive(:find_by_uuid).with('foo').and_return(mock_model(User))
      get :index, {}, {:user_id => 'foo'}
      response.should render_template('index')
    end
  end

end