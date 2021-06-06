class CreateLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :links do |t|
      t.text :uri, null: false
      t.string :slug, null: false
      t.references :user, null: false, foreign_key: true
      t.integer :click_count, null: false, default: 0

      t.timestamps
    end

    add_index :links, :slug, unique: true
  end
end
