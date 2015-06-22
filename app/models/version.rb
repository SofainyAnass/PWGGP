class Version < ActiveRecord::Base
  
  
  
  belongs_to :datafile
  
  has_one :file_version_relations, :foreign_key => :version_id,
                                     :dependent => :destroy
  
  has_one :est_version_de, :through => :file_version_relations, :source => :fichier
  
  
  def est_version_de?(file)
       file_version_relations.find_by_file_id(file)
    end
  
  def ajouter_au_fichier!(file)
       file_version_relations.create!(:datafile_id => file.id)
  end
     
     
  def retirer_du_fichier!(file)
      file_version_relations.find_by_file_id(file).destroy
  end
  
  
  
end
