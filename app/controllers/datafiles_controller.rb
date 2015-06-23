class DatafilesController < ApplicationController
  
  
  def new
    @datafile = Datafile.new  
    @titre = "Ajouter un fichier"
  end
  
  def create
    
    @titre = "Ajouter un fichier"
    @datafile = Datafile.new
    
    if (params[:datafile] != nil && (params[:version]!=nil && !params[:version].empty?) )      
  

      if @datafile.sauvegarde(:attachment => params[:datafile][:attachment])
              
           if @datafile.upload
                  
             
             @version=@datafile.versions.build(:nom => params[:version], :chemin => @datafile.chemin_par_defaut)
              
             @version.save!

             
             flash[:success]="Le fichier a été correctement chargé."
           
             redirect_to :back
             
           end
         
      end
      
  
    else
      
      flash[:error]="Champ obligatoire non renseigné."
        
      
    end
    
    render '/datafiles/new'
    
  end
  
  
  def index
    @datafiles = Datafile.paginate(:page => params[:page])
    @datafiles.first == nil ?  @datafile = Datafile.new :
    @titre="Tout les fichiers"
    render 'show_files'
  end
  
  
private

  def datafile_params
      params.require(:datafile).permit(:attachment)
  end


  
  
end
