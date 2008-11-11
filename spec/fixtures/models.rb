class Post < ActiveRecord::Base
  versioning do
    field :title
    set_repository '/tmp/.data/git_store.git'
  end
end

class Hat < ActiveRecord::Base
  set_table_name 'posts'
  versioning do
    field :title, :body
    set_repository '/tmp/.data/git_store.git'
  end
end


class Monkey < ActiveRecord::Base
  set_table_name 'posts' # lazy
  versioning do
    field :title
    commit :message => proc{ "Committed by #{current_user}" } # :current_user
    set_repository '/tmp/.data/git_store.git'
  end
  
  def current_user
    "Joseph"
  end
end