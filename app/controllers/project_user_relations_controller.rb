class ProjectUserRelationsController < ApplicationController
end

private
  
  def relationships_params
      params.require(:relationship).permit(:project_id)
  end