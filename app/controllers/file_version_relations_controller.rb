class FileVersionRelationsController < ApplicationController
  
  
  
  
  private
  
  def file_version_relation_params
      params.require(:file_version_relation).permit(:nom)
  end
  
  
  
end
