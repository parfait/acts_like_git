class Post < ActiveRecord::Base
  versioning do
    field :title
    set_repository '/tmp/.data/git_store.git'
  end
end