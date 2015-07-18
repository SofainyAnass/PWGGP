class ProjectsController < ApplicationController

  before_filter :authenticate
  #before_filter :admin_user,   :only => [:index, :destroy]
  
  def new  
    @project ||= Project.new
    @titre = "Nouveau projet"
  end

  def create  
    @project = current_user.projects.build(project_params)
    @titre = "Nouveau projet"
    if @project.save
      flash[:success] = "Project créé !"
      redirect_to projects_path
    else
      render 'new'
    end
  end

  def edit    
    @project = Project.find(params[:id])
    @titre = "Edition du projet"
  end

  def update
    @project = Project.find(params[:id])
    @titre = "Édition du projet"
    if @project.update_attributes(project_params)
      flash[:success] = "Projet édité."
      redirect_to projects_path      
    else
      render 'edit'
    end
  end

  def show  
    @project = Project.find(params[:id])
    @users = @project.membres.paginate(:page => params[:page])
    @user = User.new
    @user.contact=Contact.new
    @titre = "Fiche du projet : #{@project.nom}"
  end
  
  def index
    @project = Project.new
    @projects = Project.paginate(:page => params[:page])
    @projects.first == nil ?  @project = Project.new :   
    @titre="Tout les projets"
  end
  
  def destroy
    if Project.find(params[:id]).destroy
      flash[:success] = "Projet supprimé."
      redirect_to projects_path
    else
      render projects_path
    end
  end 
  
  def members   
    @project=Project.find(params[:id])   
    @users = @project.membres.paginate(:page => params[:page])
    @users.first == nil ?  @user = User.new :
    @titre="Membres du projet "
    render "show_users"
       
  end 
  
  def add_member    
           
    name = params[:contact_name].split(' ')
    @project=Project.find(params[:id])   
    @user=Contact.find_by(:prenom => name[0],:nom => name[1]).user
    @user.ajouter_au_projet!(@project)
    @titre="Membres du projet "
    
    respond_to do |format|
        format.html { redirect_to :back }
        format.js   { }
    end
    
  end 
  
  def remove_member    
    
    @project=Project.find(params[:id])   
    @user=User.find(params[:user_id])
    @user.retirer_du_projet!(@project)
    @titre="Membres du projet "
    
    respond_to do |format|
        format.html { redirect_to :back }
        format.js   { }
    end
    
  end 
  
  
 
 private
  
  def project_params
      params.require(:project).permit(:nom, :datedebut, :etat)
  end
  
end
