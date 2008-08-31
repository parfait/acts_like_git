module ActsLikeGit
  module ActiveRecord
    # This module covers the methods that allow rollback and other bits and pieces
    # 
    module VersionMethods
      
      def showing_latest_revision?
        self.version.blank? ? true : false
      end
      
      # Return the count of commits in git
      def versions
        self.git.commits
      end
      
      # Revert the database version to the git commit version
      def revert_to(version_hash)
        # Revert the git repository to 
        # For each field on this model that is versioned
        
        
      end
      
    end
  end
end