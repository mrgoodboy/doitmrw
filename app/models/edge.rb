class Edge < ActiveRecord::Base
  attr_accessible :weight, :user, :content

  belongs_to :user
  belongs_to :content

  
end
