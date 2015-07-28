class UsersController < ApplicationController

  before_filter :verify_connection, :except => [:create]
  before_filter :not_idle, :except => [:index]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => [:index, :destroy]
    
  def index
    
      @user = User.new
      @users = User.all      
      
      #@roster = clientxmpp.roster
      
      if(@users.empty? == false)
      
        clientxmpp.get_activities(@users) 
      
      end   
      
      @titre = "Tous les utilisateurs"
      @id = "users"

  end
  
  def following   
     
      if(params[:sidemenu]!=nil)       
        
          Thread.new do 
             
                begin 
                  
                  @user = User.find(params[:id])    
                  @users = @user.following
                  
                  
                  @users.sort_by{|e| e.contact.organization.id }
                
                  if(@users.empty? == false)
                    
                    clientxmpp.get_activities(@users) 
                    
                 end 
  
                  @cu_roster = @users
          
                  @cu_roster.sort_by{|e| e.last_activity(@clientxmpp,@current_user)}
                  
                  render 'index_sidemenu'
                      
                rescue Exception => e  
                    puts e.message  
                    #puts e.backtrace.inspect      
                end   
              
           end       
            
      else
        
          @user = User.find(params[:id])    
          @users = @user.following
          
          
          @users.sort_by{|e| e.contact.organization.id }
        
          if(@users.empty? == false)
            
            clientxmpp.get_activities(@users) 
            
          end 
          @titre = "Contacts de #{@user.contact.nom_complet}"
          @id = "user_followings"
        
          render 'index'
      
      end   
    
    
  end
  
  def show
    @user = User.find(params[:id])
    @titre = @user.contact.nom_complet
  end

  def new
    @user=User.new   
  end
  
  def create
  
    begin
         @user = User.new(user_params) 
         @user.save!
         @user.contact=Organization.create!(:nom => "Nom organisation").contacts.create!            
         Datadirectory.new_user(@user)          
         flash[:success] = "Le compte a été correctement créé."  
         
    rescue Exception => e  
         @user.delete
         puts e.message  
         puts e.backtrace.inspect 
         flash[:error] = e.message
    
    end
    
    redirect_to :back  

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
    
    if @user!=current_user && @user.en_ligne?(current_user)
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

    redirect_to :controller => 'projects', :action => 'index', :id => @user.id
    
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
     
    redirect_to :controller => 'datafiles', :action => 'index', :user_id => @user.id
  end
  
  def messages_utilisateur
   
    @user = User.find(params[:id])

    redirect_to :controller => 'messages', :action => 'index', :id => @user.id
    
              
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
