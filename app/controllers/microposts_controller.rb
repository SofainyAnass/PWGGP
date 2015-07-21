class MicropostsController < ApplicationController
  
  before_filter :verify_connection
  before_filter :authorized_user, :only => :destroy
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    @titre = "Acceuil"
    if @micropost.save
      flash[:success] = "Publication créée !"
      redirect_to root_path
    else
      @microposts = []
      render 'pages/acceuil'
    end
  end

  def destroy   
    @user=@micropost.user    
    if @micropost.destroy
      flash[:success] = "Publication supprimée !"
      redirect_to feed_user_path(@user)
    else
      render feed_user_path(@user)
    end
    
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


