class ProjectsController < ApplicationController
  def new
    @titre = "Nouveau projet"
    @project = Project.new
  end

  def create
    @titre = "Nouveau projet"
    @project = current_user.projects.build(project_params)
    if @project.save
      flash[:success] = "Project créé !"
      redirect_to projects_path
    else
      render 'new'
    end
  end

  def edit
    @titre = "Edition du projet"
    @project = Project.find(params[:id])
  end

  def update
    @titre = "Édition du projet"
    @project = Project.find(params[:id])
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
    @titre="Projets"
    @projects=Project.paginate(:page => params[:page])
  end
  
  def destroy
    if Project.find(params[:id]).destroy
      flash[:success] = "Projet supprimé."
      redirect_to projects_path
    else
      render projects_path
    end
  end 
 
 private
  
  def project_params
      params.require(:project).permit(:nom, :datedebut)
  end
  
end
