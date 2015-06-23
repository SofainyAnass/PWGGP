class Datafile < ActiveRecord::Base
  
  @@chemin_upload = "public/uploads"
  
  has_many :versions
  
  has_many :file_version_relations, :foreign_key => :datafile_id, :dependent => :destroy
  
  validates :nom, :presence => true , :uniqueness => true
  
  has_many :historique_versions, :through => :file_versions_relations, :source => :version
  
  default_scope -> { order(:created_at => :desc) }
  
  attr_accessor :flux, :chemin_upload

   
  def upload
    
    File.open(Rails.root.join(@@chemin_upload, nom), 'wb') do |file|
        file.write(@flux.read)
    end
    
  end
  
  def recup_infos(arg)
   
    @flux=arg[:attachment]
    self.nom = flux.original_filename
    self.type_contenu = flux.content_type
    self.extension = File.extname(nom)

  end
  
  def chemin_par_defaut
    return @@chemin_upload
  end
  
  
end
