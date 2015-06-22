class ProjectsController < ApplicationController
  include SessionsHelper
  
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :admin_user,   :only => [:index, :destroy]
  
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
    @titre = "#{@project.nom}"
  end
  
  def index
    @projects = Project.paginate(:page => params[:page])
    @projects.first == nil ?  @project = Project.new :
    @titre="Tout les projets"
    render 'show_projects'
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
    @projet=Project.find(params[:id])   
    @users = @projet.membres.paginate(:page => params[:page])
    @users.first == nil ?  @user = User.new :
    @titre="Membres du projet #{@projet.nom}"
    render "show_users"
       
  end 
  
  
 
 private
  
  def project_params
      params.require(:project).permit(:nom, :datedebut, :etat)
  end
  
end
