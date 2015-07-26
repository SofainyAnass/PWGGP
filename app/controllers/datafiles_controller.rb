
class DatafilesController < ApplicationController  
  include SessionsHelper
  
  
  before_filter :verify_connection
  before_filter :not_idle
  
  def new
    
    @datafile = Datafile.new  
    @titre = "Ajouter un fichier"  
    
    if(params[:fichier_id].to_i == 0)
      @fichier_id = params[:id]    
    else
      @fichier_id = params[:fichier_id]
    end

  end
  
  def create
        
    
        @titre = "Ajouter un fichier"
      
        if(params[:datafile][:attachment] != nil)               
         
          attributs=Datadirectory.build_datafile_attributs(datafile_params,current_user.id)
       
        end
        
        if(attributs != nil)
          
          @datafile=current_user.datafiles.build(attributs)
             
          #Datadirectory.upload(params[:datafile][:attachment],@datafile.chemin)
           
             begin
             
               Datadirectory.upload_ftp(current_user,params[:datafile][:attachment].path,@datafile)
               
               @datafile.save!
               
               flash[:success]="Le fichier a été correctement ajouté." 
              
             rescue Exception => e
               puts e.message  
               puts e.backtrace.inspect       
               flash[:error]="Le fichier n'a pas été chargé. Veuillez verifier la connexion avec le serveur de fichier." 
               
             end                       
                   
        else
            
            flash[:error]= "Format de fichier non autorisé."            
          
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
  
  def user_files
    
    @user_files = Datadirectory.get_user_files(current_user.id)
    @list = Datadirectory.list_ftp(Datadirectory.get_user_file_dir(current_user.id))
    puts "LIST"
    puts @list
    
    @datafiles = Datafile.paginate(:page => params[:page])
    @datafiles.first == nil ?  @datafile = Datafile.new :
    @titre="Tout les fichiers"
    render 'show_files'
    
  end
  
  
  def index
    #@user_files = Datadirectory.get_user_files(current_user.id)
    @datafiles = Datafile.paginate(:page => params[:page])
    @datafile = Datafile.new 
    @titre="Tout les fichiers"
    render 'show_datafiles'
  end
  
  def destroy  
    
    @datafile=Datafile.find(params[:id]) 
    
    if Datafile.destroy(@datafile)       
          flash[:success] = "Fichier supprimé."                     
    end
        
    
    redirect_to :back  
         
  end
  
  def download
    
    begin
      
      @datafile=Datafile.find(params[:id])
         
      temp=Tempfile.new([File.basename(@datafile.nom,File.extname(@datafile.nom)),File.extname(@datafile.nom)],'tmp') 
      Datadirectory.get_file_ftp(@datafile.chemin,File.absolute_path(temp))
      send_file temp, :type=>@datafile.type_contenu   
      
    rescue Exception => e
      puts e.message  
      puts e.backtrace.inspect       
      flash[:error]="Une erreur est survenue lors de la récuperation du fichier."   
      redirect_to :back
    
    end
    
    
    
  end
  
  def delete_file  

      @datafile=Datafile.find(params[:id]) 

                    
      if @datafile.fichier_id.to_i == 0       
        
          begin
            res = @datafile.actualiser_versions_anterieures
     
            Datadirectory.delete_ftp(@datafile.chemin)
            Datafile.destroy(@datafile)    
           
            if(res)
                 
               flash[:success] = "Toutes les versions du fichier ont été supprimées."        
                 
            else
                   
               flash[:success] = "Version supprimée." 
                   
            end   
             
          rescue Exception => e
             puts e.message  
             puts e.backtrace.inspect       
             flash[:error]="Une erreur est survenue lors de la suppression. Le fichier n'a pas été supprimé"      
          end
                    
     else
       
          begin
            Datadirectory.delete_ftp(@datafile.chemin)
            Datafile.destroy(@datafile)    
            flash[:success] = "Version supprimée."
            
          rescue Exception => e
            
            puts e.message  
            puts e.backtrace.inspect       
            flash[:error]="Une erreur est survenue lors de ka suppression. Le fichier n'a pas été supprimé"      
          end
           
      end

      redirect_to fichiers_utilisateur_user_path(current_user.id)  
      
    
  end
  
  
  def versions_fichier
    
    id = params[:id].to_i
    
    fichier_id = params[:fichier_id].to_i
    
    @datafiles = Array.new
    
    
    if(fichier_id == 0)
      
      first_file = Datafile.find_by_id(id)  
       
    else
      
      first_file = Datafile.find_by_id(fichier_id)
      
      Datafile.where(:fichier_id => fichier_id).each do | file |
        
           @datafiles.push(Datafile.find(file.id))
        
      end
      
    end
    
    @datafiles.push(first_file)

    @titre="Versions du fichier \" #{Datafile.find(params[:id]).nom} \" "
    
    render 'show_versions'
    
  end
  

  
private

  def datafile_params
      params.require(:datafile).permit(:fichier_id, :attachment, :description)
  end
  
 


  
  
end
