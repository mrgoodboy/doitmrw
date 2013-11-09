class Edge < ActiveRecord::Base
  attr_accessible :weight, :user, :content, :user_id, :content_id, :category_id

  belongs_to :user
  belongs_to :content

  validates_uniqueness_of :user_id, :scope => [:content_id]

end
