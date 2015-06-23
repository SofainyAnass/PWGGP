class DatafilesController < ApplicationController
  
  
  def new
    @datafile = Datafile.new  
    @titre = "Ajouter un fichier"
  end
  
  def create
    
    @titre = "Ajouter un fichier"
    @datafile = Datafile.new
    
    if (params[:datafile] != nil && (params[:version]!=nil && !params[:version].empty?) )      

          @datafile.recup_infos(:attachment => params[:datafile][:attachment])
      
          if( Datafile.find_by(:nom =>  @datafile.nom) != nil )
                
               @datafile = Datafile.find_by(:nom =>  @datafile.nom)
          
          else
            
               @datafile.upload
              
          end  
            
          @version=@datafile.versions.build(:nom => params[:version], :chemin => @datafile.chemin_par_defaut)
           
         
          if(Version.find_by(:nom =>  @version.nom,:datafile_id =>  @datafile.id) != nil)
            
              flash[:error]="La version indiquée du fichier existe déjà."

              
          else
              
              @version.save!
              @datafile.save!
              
              flash[:success]="Le fichier a été correctement chargé."
               
            
          end  
  
    else
      
      flash[:error]="Champ obligatoire non renseigné."
      
      
    end
    
    redirect_to :back
    
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
