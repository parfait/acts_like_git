module ActsLikeGit
  module ActiveRecord
    # This module covers the specific git interaction.
    # 
    module Git
      
      # List all the fields that have changed that we version
      def changed_versioned_fields
        return [] unless changed?
        self.git_settings.versioned_fields & self.changes.keys.collect {|f| f.intern }
      end
      
      # Add all the changes to this model to git
      def git_commit
        # We haven't been created yet, so this is revision 1
        # We don't version if we only have 1 revision
        # And we don't version if the :version field has a hash in it
        return if self.id.nil? or self.version.nil?
        init_structure
        add_all_changes_to_git
      end
      
      # Return a list of commits strings for this model
      def log
        model_folder = self.class.to_s.tableize
        model_id = self.id.to_s
        commits = self.git.log(
          File.join(model_folder, model_id)
        )
        commits.collect {|c| c.id }
      end
      
    private
      def init_structure
        @model_folder = self.class.to_s.tableize
        @model_id = self.id.to_s
        @user = Struct.new(:name => "ActsAsGit", :user => 'aag@email.com')
      end
      
      def add_all_changes_to_git
        last_commit = self.git.commits.first rescue nil
        last_tree = last_commit.tree.id rescue nil
        
        i = self.git.index
        i.read_tree(last_tree)
        
        changed_versioned_fields.each do |field|
          old_contents = changes[field.to_s][0]
          i.add(field_path(field), old_contents)
        end
        pp i
        commit_all(i, last_commit)
      end
      
      # returns new commit sha
      def commit_all(index, last_commit, last_tree)
        message = "new version of #{self.class}, id: #{self.id.to_s}"
        lc = (last_commit ? [last_commit.id] : nil)
        index.commit(message, lc, @user, last_tree)
      end
      
      def field_path(field)
        File.join(@model_folder, @model_id, "#{field}.txt")
      end
    end
  end
end