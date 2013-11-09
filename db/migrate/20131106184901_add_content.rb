class AddContent < ActiveRecord::Migration
  def change
    create_table :content do |t|
      t.references :type
      t.references :category
      t.references :user

      t.string :text # holds either a URL or the content's text

      t.timestamps
    end
  end
end
