class UsersController < ApplicationController
  include SessionsHelper
  
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
    
  def index
    @titre = "Tous les utilisateurs"
    @users = User.paginate(:page => params[:page])
  end
  
  def show
    @micropost = Micropost.new
    @feed_items = current_user.feed.paginate(:page => params[:page])
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @titre = @user.nom
  end

  def new
    @user = User.new
    @titre = "Nouvelle inscription"
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Bienvenue dans l'Application Exemple !"
      redirect_to @user
    else
      @titre = "Nouvelle inscription"
      render 'new'
    end
  end
  
  def edit
    @titre = "Édition profil"
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profil actualisé."
      redirect_to @user
    else
      @titre = "Édition profil"
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Utilisateur supprimé."
    redirect_to users_path
  end
  
  def following
    @titre = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @titre = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

private

  def user_params
      params.require(:user).permit(:nom, :email, :password, :password_confirmation)
  end
  
  def correct_user
      @user = User.find(params[:id])
      redirect_to('/pages/acceuil') unless current_user?(@user)
  end
  
  def admin_user
      redirect_to(root_path) unless current_user.admin?
  end
  
end
