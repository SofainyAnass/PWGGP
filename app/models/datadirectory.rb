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
    nom =  sanitize_filename(fichier.original_filename)
    type_contenu =  fichier.content_type
    extension = File.extname(nom)       
    
    if( !format_check(extension) )
      return nil
    end
    
    chemin = Rails.root.join(Datadirectory.get_user_file_dir(attached_to_id),nom)
    
    
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
  
  def self.sanitize_filename(filename)
    filename.strip.tap do |name|
      # NOTE: File.basename doesn't work right with Windows paths on Unix
      # get only the filename, not the whole path
      name.sub! /\A.*(\\|\/)/, ''
      # Finally, replace all non alphanumeric, underscore
      # or periods with underscore
      name.gsub! /[^\w\.\-]/, '_'
      
      name = "#{File.basename(name, ".*")}_#{Time.current.to_formatted_s(:number)}#{File.extname(name)}"
      
      return name
      
    end
  end
  
   def self.format_check(extension)
      
      formats = [".txt",".pdf",".doc",".docx",".xls",".xlsx"]
      
      if(!formats.include?(extension))
        return false
      end
      
      return true
   
  end
  
  
  
 
  
end
