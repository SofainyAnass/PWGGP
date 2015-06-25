class Datadirectory
    
  @@data_dir_name = "data"  
  @@users_dir_name ="users"
  @@files_dir_name ="files"
  
  def self.new_user(user_id)
    
    Dir.mkdir(Rails.root.join(@@data_dir_name,@@users_dir_name,user_id.to_s))
    
    Dir.mkdir(Rails.root.join(@@data_dir_name,@@users_dir_name,user_id.to_s,@@files_dir_name))
          
  end
  
  def self.get_user_file_dir(user_id)
       
    Rails.root.join(@@data_dir_name,@@users_dir_name,user_id.to_s,@@files_dir_name)
          
  end
  
  

  
end
