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
        tree = self.git.tree(version_hash)
        dir = tree.contents[0]
        data = dir.contents[0]
        data.contents.each do |f|
          field = f.name.gsub(".txt","")
          send("#{field.to_sym}=", f.data)
        end
        save
      end
    end
  end
end