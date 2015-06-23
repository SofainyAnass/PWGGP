class Datafile < ActiveRecord::Base
  
  @@chemin_upload = "data/uploads"
  
  has_many :versions, :dependent => :destroy

  validates :nom, :presence => true , :uniqueness => true
  
  default_scope -> { order(:created_at => :desc) }
  

  attr_accessor :attachment, :nouveau_chemin
   
  def upload
    
    File.open(nouveau_chemin, 'wb') do |file|
        file.write(attachment.read)
    end
    
    
  end
  
  def self.recup_infos(arg)
   
    fichier=arg[:attachment]
    nom =  fichier.original_filename
    type_contenu =  fichier.content_type
    extension = File.extname(nom)
    
    nouveau_nom="#{File.basename(nom, ".*")}_#{Time.current.to_formatted_s(:number)}#{File.extname(nom)}"    
    nouveau_chemin=Rails.root.join(@@chemin_upload, nouveau_nom)
    
    res = Datafile.find_by(:nom => nom)
    
    if( res != nil )
                          
               datafile = res    
               datafile.attachment = fichier  
               datafile.nouveau_chemin = nouveau_chemin
    else
          
               datafile = self.new(:nom => nom, :type_contenu => type_contenu, :extension => extension, :attachment => fichier, :nouveau_chemin => nouveau_chemin  )
    end
    
    return datafile

  end
  
  
end
