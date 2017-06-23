module IGDB
  class Base
    @@headers = { 'X-Mashape-Key' => ENV["IGDB_API_KEY"] }
    @@base_url = "https://igdbcom-internet-game-database-v1.p.mashape.com/"


    def self.search(query, fields = nil, filter = nil, limit = nil, offset = nil)
      url = "#{@@base_url}/#{@path}/?search=#{query}&fields="
      url += fields || @defualt_fields
      url += "&filter#{filter}" if filter
      url += "&limit=#{limit}" if limit
      url += "&offset=#{offset}" if offset
      HTTParty.get(url, headers: @@headers)
    end

    def self.all(fields = nil, filter = nil, order = nil, offset = 0, limit = 20)
      url = "#{@@base_url}/#{@path}/?fields="
      url += fields || @defualt_fields
      url += "&filter#{filter}" if filter
      url += "&order="
      url += order || @order
      url += "&limit=#{limit}"
      url += "&offset=#{offset}"
      HTTParty.get(url, headers: @@headers)
    end
  end

  class Game < IGDB::Base
    @path = "games"
    @defualt_fields = "name,release_dates.platform,cover.cloudinary_id,game_modes"
    @order = "popularity:desc"
  end

  class Platform < IGDB::Base
    @path = "platforms"
    @defualt_fields = "name"
    @order = "generation:desc"
  end
end
