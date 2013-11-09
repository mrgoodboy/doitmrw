class AddEdges < ActiveRecord::Migration
  def change
    create_table :edges do |t|
      t.references :user
      t.references :content
      t.float :weight
    end
  end
end
