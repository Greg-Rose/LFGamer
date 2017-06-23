module IGDB
  class Base
    @@headers = { 'X-Mashape-Key' => ENV["IGDB_API_KEY"] }
    @@base_url = "https://igdbcom-internet-game-database-v1.p.mashape.com/"
    @@defualt_fields = "name,release_dates.platform,cover.cloudinary_id,game_modes"

    def self.search(query, fields = nil, filter = nil, limit = nil, offset = nil)
      url = "#{@@base_url}/#{@path}/?search=#{query}&fields="
      fields.nil? ? url += @@defualt_fields : url += fields
      url += "&filter#{filter}" if filter
      url += "&limit=#{limit}" if limit
      url += "&offset=#{offset}" if offset
      HTTParty.get(url, headers: @@headers)
    end
  end

  class Game < Base
    @path = 'games'
    # def search_url(query)
    #   "https://igdbcom-internet-game-database-v1.p.mashape.com/games?#{query}"
    # end
    # def self.search(query)
    #   HTTParty.get(search_url(query), headers: headers).parsed_response
    # end
  end

  class Platform < Base
    @path = 'platforms'
  end
end
