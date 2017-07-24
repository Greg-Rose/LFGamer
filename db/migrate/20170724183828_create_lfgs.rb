class CreateLfgs < ActiveRecord::Migration[5.1]
  def change
    create_table :lfgs do |t|
      t.belongs_to :ownership, index: true
      t.string :specifics
      t.boolean :show_console_username, default: false

      t.timestamps
    end
  end
end
