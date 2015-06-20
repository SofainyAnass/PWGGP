class MicropostsController < ApplicationController
  include SessionsHelper
  
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    @titre = "Acceuil"
    if @micropost.save
      flash[:success] = "Micropost crée avec succès !"
      redirect_to root_path
    else
      @feed_items = []
      render 'pages/acceuil'
    end
  end

  def destroy
    @micropost.destroy
    redirect_back_or @micropost.user
  end
  
  private
  
  def micropost_params
      params.require(:micropost).permit(:content)
  end
  
  def authorized_user
      @micropost = Micropost.find(params[:id])
      redirect_to root_path unless current_user?(@micropost.user)
    end

end


