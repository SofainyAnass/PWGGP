class FileVersionRelationsController < ApplicationController
  
  before_filter :authenticate
  
  
  
  
  private
  
  def file_version_relation_params
      params.require(:file_version_relation).permit(:nom)
  end
  
  
  
end
