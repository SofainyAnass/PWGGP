class VersionsController < ApplicationController
  include SessionsHelper
  
  before_filter :authenticate
  
  def index
    @datafile=Datafile.find(params[:id])
    @versions = @datafile.versions.paginate(:page => params[:page]) if @datafile.respond_to?(:versions)
    @version = Version.new 
    @titre="Historique des versions du fichier \" #{@datafile.nom} \" "
    render 'show_versions'
  end
  
  def destroy  
  
    @version=Version.find(params[:id]) 
    @datafile=@version.datafile
    
    if @datafile.versions.count>1
      
          if Version.destroy(@version)       
             
             flash[:success] = "Version supprimée."
             
              redirect_to :back 
          
          end


    else
           if Version.destroy(@version) && @datafile.destroy      
              
              flash[:success] = "Toutes les versions du fichier ont été supprimées."
        
              redirect_to datafiles_path
              
           end
                                  
    end
    
       
     

         
  end
  
  
   
  def download
    @version=Version.find(params[:id])
    send_file @version.chemin, :type=>@version.datafile.type_contenu 
  end
  
  
  
  
end
