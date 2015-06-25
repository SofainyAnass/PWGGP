
class DatafilesController < ApplicationController  
  include SessionsHelper
  
  before_filter :authenticate
  
  def new
    @datafile = Datafile.new  
    @titre = "Ajouter un fichier"
  end
  
  def create
    
    @titre = "Ajouter un fichier"
    
    if (params[:datafile] != nil && (params[:version]!=nil && !params[:version].empty?) )      

          @datafile=Datafile.recup_infos(:attachment => params[:datafile][:attachment])
        
          @version=@datafile.versions.build(:nom => params[:version], :chemin => Rails.root.join(Datadirectory.get_user_file_dir(current_user.id), @datafile.nouveau_nom), :user_id => current_user.id )         
         
          if(Version.find_by(:nom =>  @version.nom,:datafile_id =>  @datafile.id) != nil)
            
              flash[:error]="La version indiquée du fichier existe déjà."          
          else        
            
              @version.save!
              @datafile.update_attributes(:updated_at => @version.updated_at)
              @datafile.save!       
              @datafile.upload(Datadirectory.get_user_file_dir(current_user.id))
                   
              flash[:success]="Le fichier a été correctement chargé."                        
          end   
    else     
      flash[:error]="Champ obligatoire non renseigné."          
    end
    
    redirect_to :back
    
  end
  
  def edit   
    @title = "Modfier un fichier"
  end
  
  def update 
    @datafile=Datafile.find(params[:id])
    @datafile.update_attributes!(params[:product].reject { |k,v| v.blank? })
    flash[:success] = "Fichier mis à jour."
    redirect_to datafiles_path
    
  end
  
  
  def index
    @datafiles = Datafile.paginate(:page => params[:page])
    @datafiles.first == nil ?  @datafile = Datafile.new :
    @titre="Tout les fichiers"
    render 'show_files'
  end
  
  def destroy  
  
    @datafile=Datafile.find(params[:id]) 
    
    if Datafile.destroy(@datafile)       
          flash[:success] = "Fichier supprimé."                     
    end
        
    
    redirect_to :back  
         
  end
  
  
   
  def download
    @datafile=Datafile.find(params[:id])
    send_file @datafile.chemin_complet, :type=>@datafile.type_contenu 
  end
  
  
  
  
private

  def datafile_params
      params.require(:datafile).permit(:attachment)
  end


  
  
end
