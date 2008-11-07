module ActsLikeGit
  class ModelInit
    # The Builder class is the core for the versioning definition block processing.
    # There are two methods you really need to pay attention to:
    #
    # - set_repository (aliased to location)
    # - field
    #
    # The repository is an optional declaration that defines where the git 
    # repository will be saved.  You only need declare this once, you could
    # have a different repository per model if you wanted.  But why would you?
    #
    # The field method defines which field will be stored in the repository.
    # 
    class Builder
      class << self
        # No idea where this is coming from - haven't found it in any ruby or
        # rails documentation. It's not needed though, so it gets undef'd.
        # Hopefully the list of methods that get in the way doesn't get too
        # long.
        undef_method :parent
        
        attr_accessor :repository, :versioned_fields
        
        # Set up all the collections. Consider this the equivalent of an
        # instance's initialize method.
        # 
        def setup(model_name)
          root = defined?( RAILS_ROOT ) ? RAILS_ROOT : "/.data"
          @repository       = File.join( root, "git_store" )
          @versioned_fields = []
        end
        
        # This is how you add a field to acts_like_git.  It takes a 
        # symbol of the field name to version.
        #
        # Example
        #
        # field :body
        #
        def field(column)
          @versioned_fields << column
        end
                
        # acts_like_git needs a repository to save the versions 
        # in, without it, life just can't go on.  Pass in a 
        # file_path, or leave this to the default: 'RAILS_ROOT/git_store/#{plural_model_name}'
        #
        # Example
        #
        # set_repository '/my/file/path'
        # 
        # 
        def set_repository(file_path)
          # TODO - More file checks
          @repository = file_path
        end
        alias_method :set_location, :set_repository
        alias_method :location,     :set_repository
        
      end
    end
  end
end
