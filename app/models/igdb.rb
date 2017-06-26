# Video game API from IGDB.com
# API documenation at https://igdb.github.io/api/about/welcome/
module IGDB
  class Base
    @@headers = { 'X-Mashape-Key' => ENV["IGDB_API_KEY"] }
    @@base_url = "https://igdbcom-internet-game-database-v1.p.mashape.com/"

    # Search the IGDB API with specific query
    #
    # params:
    #   query   = string that is name of what you're searching for
    #   fields  = (optional) string of fields separated by commas
    #   filters = (optional) array of strings, each being a filter
    #   limit   = (optional, API default = 10) int for number of returned results
    #   offset  = (optional) int for offsetting returned search results
    # return:
    #   an array of hashes
    def self.search(query, fields = nil, filters = nil, limit = nil, offset = nil)
      url = "#{@@base_url}/#{@path}/?search=#{query}&fields="
      url += fields || @defualt_fields
      url += generate_filters(filters) if filters
      url += "&limit=#{limit}" if limit
      url += "&offset=#{offset}" if offset
      HTTParty.get(url, headers: @@headers).parsed_response
    end

    def self.all(fields = nil, filters = nil, order = nil, offset = 0, limit = 20)
      url = "#{@@base_url}/#{@path}/?fields="
      url += fields || @defualt_fields
      url += generate_filters(filters) if filters
      url += "&order="
      url += order || @order
      url += "&limit=#{limit}"
      url += "&offset=#{offset}"
      HTTParty.get(url, headers: @@headers).parsed_response
    end

    def self.find(id, fields = nil)
      url = "#{@@base_url}/#{@path}/#{id}?fields="
      url += fields || @defualt_fields
      HTTParty.get(url, headers: @@headers).parsed_response
    end

    private_class_method def self.generate_filters(filters)
      output = ""
      prefix = "&filter"

      filters.each do |f|
        output += prefix + f
      end

      output
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
