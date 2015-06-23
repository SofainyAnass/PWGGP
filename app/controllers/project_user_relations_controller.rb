class ProjectUserRelationsController < ApplicationController
  include SessionsHelper
  
  before_filter :authenticate
 
 
 
  private
  
  def project_user_relation_params
      params.require(:project_user_relation).permit(:project_id)
  end
  
  
end

