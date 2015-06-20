class UsersController < ApplicationController
  include SessionsHelper
  
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => [:index, :destroy]
    
  def index
    @titre = "Tous les utilisateurs"
    @users = User.paginate(:page => params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @titre = @user.contact.nom_complet
  end

  def new
    
  end
  
  def create
    @user = User.new(user_params)      
    if @user.save
      #sign_in @user        
      @user.contact=Contact.create! 
      flash[:success] = "Votre compte a été correctement créé. Veuillez vous authentifier pour continuer."
      redirect_to root_path
    else   
       
      render '/pages/inscription'          
      
    end
  end
  
  def edit
    @titre = "Édition compte"
    @user = User.find(params[:id])
  end
  
  def update
    @titre = "Édition profil"
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profil actualisé."
      redirect_to 'edit'      
    else
      render 'edit'
    end
  end
  
  def destroy
    if User.find(params[:id]).destroy
      flash[:success] = "Utilisateur supprimé."
      redirect_to users_path
    else
      render users_path
    end
  end
  
  def following
    @titre = "Abonnements"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @titre = "Abonnés"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end
  
  def feed
    @feed_items = current_user.feed.paginate(:page => params[:page])
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @titre = "Publications de #{@user.contact.prenom} #{@user.contact.nom}"
    render 'user_feed'
  end

private

  def user_params
      params.require(:user).permit(:nom, :login, :password, :password_confirmation)
  end
  
  def correct_user
      @user = User.find(params[:id])
      redirect_to('/pages/acceuil') unless current_user?(@user)
  end
  
  def admin_user
      redirect_to(root_path) unless current_user.admin?
  end

  
end
