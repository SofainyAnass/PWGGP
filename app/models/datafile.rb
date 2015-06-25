class Datafile < ActiveRecord::Base
  
  @@chemin_upload = "data/uploads" 
  
  
  has_many :versions, :dependent => :destroy

  validates :nom, :presence => true , :uniqueness => true
  
  default_scope -> { order(:updated_at => :desc) }
  

  attr_accessor :attachment, :nouveau_nom
   
  def upload(nouveau_chemin)
    
    File.open(File.join(nouveau_chemin,nouveau_nom), 'wb') do |file|
        file.write(attachment.read)
    end
    
    
  end
  
  def self.recup_infos(arg)
   
    fichier=arg[:attachment]
    nom =  fichier.original_filename
    type_contenu =  fichier.content_type
    extension = File.extname(nom)
    
    nouveau_nom="#{File.basename(nom, ".*")}_#{Time.current.to_formatted_s(:number)}#{File.extname(nom)}"    
  
    res = Datafile.find_by(:nom => nom)
    
    if( res != nil )
                          
               datafile = res    
               datafile.attachment = fichier  
               datafile.nouveau_nom = nouveau_nom
    else
          
               datafile = self.new(:nom => nom, :type_contenu => type_contenu, :extension => extension, :attachment => fichier, :nouveau_nom => nouveau_nom )
    end
    
    return datafile

  end
  
  
end
