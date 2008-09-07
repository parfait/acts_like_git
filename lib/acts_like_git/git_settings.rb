require 'acts_like_git/git_settings/builder'

module ActsLikeGit
  # The Index class is a ruby representation of a Sphinx source (not a Sphinx
  # index - yes, I know it's a little confusing. You'll manage). This is
  # another 'internal' Thinking Sphinx class - if you're using it directly,
  # you either know what you're doing, or messing with things beyond your ken.
  # Enjoy.
  # 
  class GitSettings
    attr_accessor :versioned_fields, :versioned_fields_values, :repository
    
    # TODO: document me
    #
    def initialize(model, &block)
      @repository       = ""
      
      initialize_from_builder( &block ) if block_given?
    end
    
    def name
      model.name.underscore.tr(':/\\', '_')
    end
    
    # TODO: document this
    #
    def initialize_from_builder(&block)
      builder = Class.new(Builder)
      builder.setup
      
      builder.instance_eval( &block )
      
      @versioned_fields_values = {}
      @versioned_fields = builder.versioned_fields
      @repository       = builder.repository
    end
  end
end
