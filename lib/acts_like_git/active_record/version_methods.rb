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
        dir = tree.contents[0] # posts/
        data = dir.contents[0] # 6/
        data.contents.each do |f| # title.txt
          field = f.name.gsub(".txt","")
          send("#{field.to_sym}=", f.data)
        end
        save # hm, not sure if I want to do this
      end

      # Find the complete (textual) history for a field
      def history(field)
        commits = self.git.log('master', "#{model_folder}/#{model_id}/#{field}.txt")
        commits.collect {|c| (c.tree/model_folder/model_id/"#{field}.txt").data }
      end
      
      # Convenience method to give you an array of hashes
      # { :id => 'aee1be..', :data => 'monkey' }
      def history_hash(field)
        commits = self.git.log('master', "#{model_folder}/#{model_id}/#{field}.txt")
        commits.inject([]) { |memo,iter|
          # You can get all sorts of information, like 'blame'
          commit = (iter.tree/model_folder/model_id/"#{field}.txt")
          memo << { :id => iter.id, :data => commit.data } #, :date => commit.committed_date }??
          memo
        }
      end

    end
  end
end