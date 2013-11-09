class AddColumnToEdges < ActiveRecord::Migration
  def change
    add_column :edges, :category_id, :integer
  end
end
