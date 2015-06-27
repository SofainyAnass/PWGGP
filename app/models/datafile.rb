class Datafile < ActiveRecord::Base
   
  
  belongs_to :user
  
  validates :description, :length   => { :maximum => 200 }
  
  default_scope -> { order(:created_at => :desc) }
  
  attr_accessor :attachment
  
  def versions_anterieures
    
    datafiles = Array.new
 
      Datafile.where(:fichier_id => self.fichier_id).each do | file |
        
           datafiles.push(Datafile.find(file.id))
        
      end
      
    return datafiles
    
    
  end
  
  def versions_anterieures
    
    datafiles = Array.new
 
      Datafile.where(:fichier_id => self.fichier_id).each do | file |
        
           datafiles.push(Datafile.find(file.id))
        
      end
      
    return datafiles
    
    
  end
  
  def derniere_version

      file = Datafile.where(:fichier_id => self.fichier_id).first
      
      datafile = Datafile.find(file.id)
      
    return datafile
    
    
  end
  
  def actualiser_versions_anterieures

      datafiles = Array.new
 
      Datafile.where(:fichier_id => self.id).each do | file |
        
           datafile = Datafile.find(file.id)         
           
           datafiles.push(datafile)
        
      end
      

     datafiles.each do | file |
        
           file.update_attributes(:fichier_id => datafiles.last.id)
        
      end
    
     if(datafiles.last != nil) 
       
       datafiles.last.update_attribute(:fichier_id, 0)
       
       return false
       
     end
     
     return true
     
  end

 
end
