class Content < ActiveRecord::Base
  attr_accessible :title, :text, :submit, :category, :type

  set_table_name 'content'

  belongs_to :category
  belongs_to :type

  def likes
    edges.count
  end

end
