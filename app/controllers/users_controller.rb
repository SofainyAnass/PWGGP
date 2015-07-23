class UsersController < ApplicationController

  before_filter :verify_connection, :except => [:create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => [:index, :destroy]
    
  def index 
      @user = User.new
      @users = User.all 
      @titre = "Tous les utilisateurs"
      @roster = clientxmpp.roster

      clientxmpp.get_activities(@users)  

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
    if @user.save!         
         #sign_in @user        
         @user.contact=Organization.create!(:nom => "Nom organisation").contacts.create!
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
     render '/projects/index'
  end
  
  def taches_attribuees
    @user = User.find(params[:id])
    @tasks = @user.charge_de.paginate(:page => params[:page])   
    @tasks.first == nil ?  @task = Task.new :   
    @titre = "Tâches attribuées à #{@user.contact.nom_complet}"
    render '/tasks/index'
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
  
   def get_events
    
    @projects = current_user.membre_de
    events = []
    @projects.each do |project|
      events << {:id => project.id, :title => "#{project.nom}", :start => "#{project.datedebut}",:end => "#{project.datefin}" }
    end
    
    respond_to do |format|
        format.html { redirect_to :back }
        format.json   { render :text => events.to_json }
    end
  end
  

private

  def user_params
      params.require(:user).permit(:nom, :login, :password, :password_confirmation)
  end
  
  def correct_user
      @user = User.find(params[:id])
      redirect_to('/') unless current_user?(@user)
  end
  

  
end
