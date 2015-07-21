class TasksController < ApplicationController
  
  before_filter :verify_connection
  
  def index
    @task = Task.new
    @tasks = Task.paginate(:page => params[:page])
    @tasks.first == nil ?  @task = Task.new :   
    @titre="Toutes les tâches"
  end
  
  def new  
    @task ||= Task.new
    @titre = "Nouvelle tâche"
  end

  def create  
  
    @task = Task.new(task_params)
    @titre = "Nouveau Tâche"
    if @task.save! 
      flash[:success] = "tâche créé !"
      redirect_to tasks_path
    else
      render 'new'
    end
  end

  def edit    
    @task = Task.find(params[:id])
    @users = @task.charges.paginate(:page => params[:page])
    @user = User.new
    @user.contact=Contact.new
    @titre = "Edition de la tâche : #{@task.nom}"
  end

  def update
    @task = Task.find(params[:id])
    @titre = "Édition du Tâche"
    if @task.update_attributes(task_params)
      flash[:success] = "Tâche éditée."
      redirect_to :back     
    else
      render 'edit'
    end
  end

  def show  
    @task = Task.find(params[:id])
    @users = @task.charges.paginate(:page => params[:page])
    @user = User.new
    @user.contact=Contact.new
    @titre = "Details de la tâche : #{@task.nom}"
  end

  
  def destroy
    if Task.find(params[:id]).destroy
      flash[:success] = "Tâche supprimée."
      redirect_to tasks_path
    else
      render tasks_path
    end
  end 
  
  def charges  
    @task=Task.find(params[:id])   
    @users = @task.charges.paginate(:page => params[:page])
    @users.first == nil ?  @user = User.new :
    @titre="Personnes chargées de #{@task.nom} "
    render "show_users"
       
  end 
  
  def add_member    
     
    @task=Task.find(params[:id])    
    name = params[:contact_name].split(' ')     
    @user=Contact.find_by(:prenom => name[0],:nom => name[1]).user
    @titre="Personnes chargées de #{@task.nom}"
    
    if(@user.charge_de?(@task))
      @user = nil
    else
      @user.attribuer_tache!(@task)
      
    end
    
      respond_to do |format|
          format.html { redirect_to :back }
          format.js   { }
      end


  end 
  
  def remove_member    
    
    @task=Task.find(params[:id])   
    @user=User.find(params[:user_id])
    @user.retirer_du_projet!(@task)
    @titre="Membres du projet "
    
  end 
  
  private
  
  def task_params
      params.require(:task).permit(:nom, :datedebut, :datefin, :etat)
  end
end
