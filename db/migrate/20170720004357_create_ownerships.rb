class CreateOwnerships < ActiveRecord::Migration[5.1]
  def change
    create_table :ownerships do |t|
      t.belongs_to :user, index: true
      t.belongs_to :games_console, index: true
      t.boolean :current, default: true

      t.timestamps
    end
  end
end
