class Datadirectory
  
  require 'net/ftp'
    
  @@data_dir_name = "data"  
  @@users_dir_name ="users"
  @@files_dir_name ="files"
  @@ftp_server = "127.0.0.1"
  @@user_name = "anonymous"
  @@pass ="anonymous"
  
  attr_accessor :attachment
  
  def self.new_user(user)
    
    create_dir_ftp(File.join(@@users_dir_name,user.id.to_s,@@files_dir_name))
    
          
  end
  
  def self.get_user_file_dir(user_id)
       
    File.join(@@users_dir_name,user_id.to_s,@@files_dir_name)
          
  end
  
  def self.upload(fichier,chemin)
    
      File.open(chemin, 'wb') do |file|
          file.write(fichier.read)          
      end
  
  
  end
  
  def self.connect_ftp
    
     ftp = Net::FTP.new(@@ftp_server)
          
     ftp.login @@user_name, @@pass
     
     ftp
     
  end
  
  def self.upload_ftp(user,chemin,datafile)

      begin 
        
          @ftp  = connect_ftp
          
          files = @ftp.chdir(File.join(@@users_dir_name,user.id.to_s,@@files_dir_name ))
          
          @ftp.put(chemin,datafile.nom)
      
      ensure
      
          @ftp.close
      
      end

  end
  
  def self.delete_ftp(chemin)

      begin 
        
          @ftp  = connect_ftp     
         
          @ftp.delete(chemin)
      
      ensure
      
          @ftp.close
      
      end

  end
  
  def self.create_dir_ftp(chemin)

     begin 
          
          @ftp = connect_ftp
                  
          parts = chemin.to_s.split("/")
                   
          i=0
          
          c="/#{parts[i]}"
          
          puts parts[i]
          
          puts c
          
          if !@ftp.list("/").any?{|dir| dir.match(/\s#{parts[i]}$/)}   
             @ftp.mkdir("#{c}")
          end   
          
          i+=1
          
          while i < parts.size do 
                  
             ipad_folder = @ftp.list("#{c}")
             
             c+="/#{parts[i]}"
             
             if !ipad_folder.any?{|dir| dir.match(/\s#{parts[i]}$/)}
                @ftp.mkdir("#{c}")
             end
             i +=1
             
          end
          
      
      ensure
      
          @ftp.close
      
      end

    
  end
  
  def self.get_file_ftp(chemin,path=nil)

      begin 
        
          @ftp  = connect_ftp     
         
          @ftp.get(chemin,path)
      
      ensure
      
          @ftp.close
      
      end

  end
  
  def self.list_ftp(chemin)

     begin 
       
          list=Array.new
          
          @ftp = connect_ftp
                  
          list = @ftp.list(chemin)    
          
      rescue Exception => e
               puts e.message  
               puts e.backtrace.inspect       

      ensure
      
          @ftp.close
          
          list
      
      end

      
  end
  
 
  
  def self.build_datafile_attributs(params,user)
   
    fichier=params[:attachment]
    description=params[:description]
    fichier_id=params[:fichier_id]
    nom =  sanitize_filename(fichier.original_filename)
    type_contenu =  fichier.content_type
    extension = File.extname(nom)       
    
    if( !format_check(extension) )
      return nil
    end
    
    chemin = File.join(get_user_file_dir(user),nom)
    
    
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
  
  def self.get_user_files(user)
    
    Dir.entries( get_user_file_dir(user.id) )
    
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
