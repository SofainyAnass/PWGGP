require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  render_views
  
  describe "GET 'show'" do

    before(:each) do
      @user = FactoryGirl.build(:user)
    end

    it "devrait réussir" do
      get :show
      response.should be_success
    end

    it "devrait trouver le bon utilisateur" do
      assigns(:user).should == @user
    end
  end
  
  describe "POST 'create'" do

    describe "échec" do

      before(:each) do
        @attr = { :nom => "", :email => "", :password => "",
                  :password_confirmation => "" }
      end

      it "ne devrait pas créer d'utilisateur" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end


      it "devrait rendre la page 'new'" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
  end

end
