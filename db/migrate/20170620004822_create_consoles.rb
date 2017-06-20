class CreateConsoles < ActiveRecord::Migration[5.1]
  def change
    create_table :consoles do |t|
      t.string :name, null: false
      t.string :logo, null: false

      t.timestamps
    end

    add_index :consoles, :name, unique: true
  end
end
