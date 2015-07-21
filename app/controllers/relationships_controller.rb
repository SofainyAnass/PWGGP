class RelationshipsController < ApplicationController
  
  before_filter :verify_connection

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    redirect_to :back
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    redirect_to :back
  end
  
  
  private
  
  def relationships_params
      params.require(:relationship).permit(:followed_id)
  end
  
end
