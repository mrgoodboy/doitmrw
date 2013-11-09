class Content < ActiveRecord::Base
  # attr_accessible :title, :body

  set_table_name 'content'

  belongs_to :category
  belongs_to :type

  def likes
    edges.count
  end

end
