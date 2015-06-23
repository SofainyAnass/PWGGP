class Version < ActiveRecord::Base  
  
  belongs_to :datafile
  
   default_scope -> { order(:created_at => :desc) }
  
  
  
  def destroy
    
    File.delete(chemin) if File.exist?(chemin)
    
    super()
    
  end
  
end
