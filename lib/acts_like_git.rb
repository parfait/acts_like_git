require 'grit'
require 'fileutils'
require 'activerecord'

require 'acts_like_git/active_record'
require 'acts_like_git/rails_additions'
require 'acts_like_git/model_init'

ActiveRecord::Base.send(:include, ActsLikeGit::ActiveRecord)

module ActsLikeGit
  module Version #:nodoc:
    Major = 0
    Minor = 0
    Tiny  = 1
    
    String = [Major, Minor, Tiny].join('.')
  end
  
  # A ConnectionError will get thrown when a connection to git can't be
  # made.
  class ConnectionError < StandardError
  end
  
  # The collection of versioned models. Keep in mind that Rails lazily loads
  # its classes, so this may not actually be populated with _all_ the models
  # that have versioned fields.
  def self.all_versioned_models
    @@versioned_models ||= []
  end
  
  # Check if versioning is disabled.
  # 
  def self.versioning_enabled?
    @@versioning_enabled =  true unless defined?(@@versioning_enabled)
    @@versioning_enabled == true
  end
  
  # Enable/disable versioning - you may want to do this while migrating data.
  # 
  #   ActsLikeGit.versioning_enabled = false
  # 
  def self.versioning_enabled=(value)
    @@versioning_enabled = value
  end
end
