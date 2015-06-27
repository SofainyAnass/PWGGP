class UsersController < ApplicationController
  
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => [:index, :destroy]
    
  def index    
    @users = User.paginate(:page => params[:page])
    @users.first == nil ?  @user = User.new :
    @titre = "Tous les utilisateurs"
    render "show_users"  
  end
  
  def show
    @user = User.find(params[:id])
    @titre = @user.contact.nom_complet
  end

  def new
    @user=User.new   
  end
  
  def create
    @user = User.new(user_params)      
    if @user.save         
         #sign_in @user        
         @user.contact=Contact.create! 
         Datadirectory.new_user(@user.id)        
         flash[:success] = "Le compte a été correctement créé."  
         redirect_to :back  
    else  
         render '/pages/inscription'
    end
  end
  
  def edit
    @titre = "Édition compte"
    @user = User.find(params[:id])
  end
  
  def update   
    @user = User.find(params[:id])
    @titre = "Édition profil"
    if @user.update_attributes(user_params)
      flash[:success] = "Profil actualisé."
      redirect_to 'edit'      
    else
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    
    if @user!=current_user
      if@user.destroy
        flash[:success] = "Utilisateur supprimé."
        redirect_to users_path
      else
        render users_path
      end
    else
      flash[:error] = "Vous ne pouvez pas supprimer ce compte tant qu'il est connecté."
      redirect_to users_path
    end
  end
  
  def following   
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    @titre = "Abonnements"
    render 'show_follow'
  end

  def followers   
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    @titre = "Abonnés"
    render 'show_follow'
  end
  
  def feed
    @feed_items = current_user.feed.paginate(:page => params[:page])
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @microposts == nil  ?  @micropost = Microposts.new :  
    @titre = "Publications de #{@user.contact.nom_complet}"
    render 'show_feeds'
  end
  
  def settings
    @user = User.find(params[:id])
    @titre = "Paramètres de #{@user.contact.nom_complet}"
  end
  
  def membre_de
    @user = User.find(params[:id])
    @projects = @user.membre_de.paginate(:page => params[:page])   
    @projects.first == nil ?  @project = Project.new :   
    @titre = "Projets de #{@user.contact.nom_complet}"
     render 'show_projects'
  end
  
  def fichiers_utilisateur
   
    @user = User.find(params[:id])
    
    @first_files = @user.datafiles.where(:fichier_id => "0") 
    
    @datafiles = Array.new
    
    @first_files.each do | first_file |
          
          
          @datafile=Datafile.where(:fichier_id => first_file.id ).first
          
          if @datafile !=nil
            @datafiles.push(@datafile)
          else
            @datafiles.push(first_file)
          end
              
    end
    
    @datafile = Datafile.new
    
    @titre = "Fichiers de #{@user.contact.nom_complet}"
    render 'show_datafiles'
  end

private

  def user_params
      params.require(:user).permit(:nom, :login, :password, :password_confirmation)
  end
  
  def correct_user
      @user = User.find(params[:id])
      redirect_to('/pages/acceuil') unless current_user?(@user)
  end
  

  
end
