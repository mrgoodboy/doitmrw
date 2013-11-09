class AddBaseTypes < ActiveRecord::Migration
  def change
    create_table :types do |t|
      t.string :name
    end
    create_table :categories do |t|
      t.string :name
      t.string :slug
    end
  end
end
