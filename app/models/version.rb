class Version < ActiveRecord::Base  
  
  belongs_to :user
  
  belongs_to :datafile
  
   default_scope -> { order(:updated_at => :desc) }
  
  
  
  def destroy
    
    File.delete(chemin) if File.exist?(chemin)
    
    super()
    
  end
  
end
