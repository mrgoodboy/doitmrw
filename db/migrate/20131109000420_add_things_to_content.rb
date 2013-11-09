class AddThingsToContent < ActiveRecord::Migration
  def change
    add_column :content, :flags, :integer
    add_column :content, :new, :boolean
    add_column :content, :title, :string
    add_index :content, :new

  end
end
