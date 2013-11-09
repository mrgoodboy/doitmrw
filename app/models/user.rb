class User < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :edges
  has_many :content, through: :edges

  

end
