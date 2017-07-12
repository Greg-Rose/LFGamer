class CreateProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :profiles do |t|
      t.belongs_to :user, index: true
      t.string :about_me
      t.string :psn_id
      t.string :xbox_gamertag
      t.string :zipcode, limit: 5
      t.boolean :psn_id_public, default: false
      t.boolean :xbox_gamertag_public, default: false
    end
  end
end
