module ActsLikeGit
  # Core additions to ActiveRecord models - Explore versioning for linking models
  # to a git repository.
  #
  module ActiveRecord
    autoload :Base,           'acts_like_git/active_record/base'  
    autoload :Callbacks,      'acts_like_git/active_record/callbacks'
    autoload :Git,            'acts_like_git/active_record/git'
    autoload :VersionMethods, 'acts_like_git/active_record/version_methods'
  end
end
