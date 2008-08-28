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
        create_git_folder_structure
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
      def create_git_folder_structure
        model_folder = self.class.to_s.tableize
        model_id = self.id.to_s
        FileUtils.mkdir_p(File.join(self.git_settings.repository, model_folder, model_id))
      end
      
      def write_field_contents_to_file(field, contents)
        file = File.open(field_path(field), 'w')
        file.puts contents
        file.close
      end
      
      def add_all_changes_to_git
        changed_versioned_fields.each do |field|
          old_contents = changes[field.to_s][0]
          write_field_contents_to_file(field, old_contents)
          add_file_to_git(field_path(field, :for_git))
        end
        commit_all
      end
      
      def add_file_to_git(file)
        self.git.add(file)
      end
      
      def commit_all
        self.git.commit_all("new version of #{self.class}, id: #{self.id.to_s}")
      end
      
      def field_path(field, git_version=nil)
        model_folder = self.class.to_s.tableize
        model_id = self.id.to_s
        git_version ? File.join(model_folder, model_id, "#{field}.txt") : 
                      File.join(self.git_settings.repository, model_folder, model_id, "#{field}.txt")
      end
    end
  end
end