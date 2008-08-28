module ActsLikeGit
  module ActiveRecord
    # This module covers the methods that allow rollback and other bits and pieces
    # 
    module VersionMethods
      
      def showing_latest_revision?
        
      end
      
      # Return the count of commits in git
      def versions
        self.git.commits.length
      end
      
      # Save the current version to git, then change current fields to match the git version
      # Then save the file
      def rollback

      end
      
    end
  end
end