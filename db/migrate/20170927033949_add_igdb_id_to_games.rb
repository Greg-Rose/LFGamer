class AddIgdbIdToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :igdb_id, :integer
    Game.all.each do |g|
      igdb_id = IGDB::Game.search(g.name, "id").first["id"]
      g.update_attributes!(igdb_id: igdb_id)
    end
  end
end
