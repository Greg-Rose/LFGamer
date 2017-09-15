class AddIgdbIdToConsoles < ActiveRecord::Migration[5.1]
  def change
    add_column :consoles, :igdb_id, :integer
    Console.all.each do |c|
      igdb_id = IGDB::Platform.search(c.name, "id").first["id"]
      c.update_attributes!(igdb_id: igdb_id)
    end
  end
end
