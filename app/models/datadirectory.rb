class Datadirectory
    
  @@data_dir_name = "data"  
  @@users_dir_name ="users"
  @@files_dir_name ="files"
  
  attr_accessor :attachment
  
  def self.new_user(user_id)
    
    Dir.mkdir(Rails.root.join(@@data_dir_name,@@users_dir_name,user_id.to_s))
    
    Dir.mkdir(Rails.root.join(@@data_dir_name,@@users_dir_name,user_id.to_s,@@files_dir_name))
          
  end
  
  def self.get_user_file_dir(user_id)
       
    Rails.root.join(@@data_dir_name,@@users_dir_name,user_id.to_s,@@files_dir_name)
          
  end
  
  def self.upload(fichier,chemin)
    
      File.open(chemin, 'wb') do |file|
          file.write(fichier.read)          
      end
  
  
  end
  
  def self.build_datafile_attributs(params,attached_to_id)
   
    fichier=params[:attachment]
    description=params[:description]
    fichier_id=params[:fichier_id]
    nom =  fichier.original_filename
    type_contenu =  fichier.content_type
    extension = File.extname(nom)    
    nouveau_nom="#{File.basename(nom, ".*")}_#{Time.current.to_formatted_s(:number)}#{File.extname(nom)}"    
    chemin = Rails.root.join(Datadirectory.get_user_file_dir(attached_to_id),nouveau_nom)
    
    
    new_version = 2
    
    if fichier_id.to_i == 0
      
      new_version = 1
    
    else
      
      datafile = Datafile.where(:fichier_id => fichier_id)
      
      if(datafile.first != nil)
          
        new_version = datafile.first.version + 1
      
      else
        
        datafile = Datafile.where(:id => fichier_id)
        
        new_version = datafile.first.version + 1
     
      end
     
        
    end


    attributs = { :nom => nom, :version => new_version, :description => description, :type_contenu => type_contenu, :chemin => chemin, :attachment => fichier, :fichier_id => fichier_id}
    
    return attributs

  end
  
  def self.get_user_files(user_id)
    
    Dir.entries( get_user_file_dir(user_id) )
    
  end
  
  def self.get_file_informations(file_path)
   
    f = File.new(file_path)    
    infos = Hash.new
    
    infos["name"] = File.basename(file_path)
    infos["owner"] = f.stat.uid
    infos["created_at"] = f.stat.ctime
    infos["updated_at"] = f.stat.mtime
    infos["permissions"] = f.stat.mode
    infos["absolute_path"] = File.absolute_path(file_path)
    
    f.close
    
    return infos
    
  end
  
  def self.download(file_path)
  
    send_file file_path
    
  end
  
  def self.delete_file(file_path)
  
    File.delete(file_path)
    
  end
  
  
  
 
  
end
