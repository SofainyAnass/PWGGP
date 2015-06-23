class Version < ActiveRecord::Base  
  
  belongs_to :datafile
  
  
  def destroy
    
    File.delete(chemin) if File.exist?(chemin)
    
    super()
    
  end
  
end
