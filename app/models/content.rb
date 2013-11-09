class Content < ActiveRecord::Base
  include GraphNode
  # attr_accessible :title, :body

  set_table_name 'content'

  belongs_to :category
  belongs_to :type

  def self.edge_column
    'content_id'
  end

  def likes
    edges.count
  end

end
