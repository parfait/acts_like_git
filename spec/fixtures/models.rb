class Post < ActiveRecord::Base
  versioning do
    field :title
  end
end