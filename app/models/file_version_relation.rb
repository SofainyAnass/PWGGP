class FileVersionRelation < ActiveRecord::Base
    
    belongs_to :fichier, :class_name => "Datafile"
    belongs_to :version, :class_name => "Version"
    
    validates :datafile_id, :presence => true
    validates :version_id, :presence => true


end
