class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.string :name, null: false
      t.string :cover_image, null: false
      t.boolean :online, null: false
      t.boolean :split_screen, null: false

      t.timestamps
    end

    add_index :games, :name, unique: true
  end
end
