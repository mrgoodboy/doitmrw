class Content < ActiveRecord::Base
  # attr_accessible :title, :body

  table_name 'content'

  belongs_to :category
  belongs_to :type

end
