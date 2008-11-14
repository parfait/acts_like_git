RAILS_ROOT = File.dirname(__FILE__)

class Post < ActiveRecord::Base
  versioning(:title) { |version|
    version.repository = '/tmp/.data/git_store.git'
  }
end

class Hat < ActiveRecord::Base
  set_table_name 'posts'
  versioning(:title, :body) do |version|
    version.repository = '/tmp/.data/git_store.git'
  end
end

class Giraffe < ActiveRecord::Base
  set_table_name 'posts'
  versioning(:title) {}
end

class Monkey < ActiveRecord::Base
  set_table_name 'posts' # lazy
  versioning(:title) do |version|
    version.message = lambda { |monkey| "Committed by #{monkey.current_user}" }
    version.repository = '/tmp/.data/git_store.git'
  end
  
  def current_user
    "Joseph"
  end
end