# Video game API from IGDB.com
# API documenation at https://igdb.github.io/api/about/welcome/
module IGDB
  class Base
    @@headers = { 'user-key' => ENV["IGDB_API_KEY"] }
    @@base_url = "https://api-2445582011268.apicast.io"

    # Search the IGDB API with specific query
    # Params:
    #   query   = string that is name of what you're searching for
    #   fields  = (optional) string of fields separated by commas
    #   filters = (optional) array of strings, each being a filter
    #   limit   = (optional, API default = 10) int for number of returned results
    #   offset  = (optional) int for offsetting returned search results
    # Return:
    #   an array of hashes
    def self.search(query, fields = nil, filters = nil, limit = nil, offset = nil)
      url = "#{@@base_url}/#{@path}/?search=#{query}&fields="
      url += fields || @defualt_fields
      url += generate_filters(filters) if filters
      url += "&limit=#{limit}" if limit
      url += "&offset=#{offset}" if offset
      HTTParty.get(url, headers: @@headers).parsed_response
    end

    # Get list of * from IGDB API
    # Params:
    #   fields  = (optional) string of fields separated by commas
    #   filters = (optional) array of strings, each being a filter
    #   order   = (optional) string that is field to order results by
    #   limit   = (optional, API default = 10) int for number of returned results
    #   offset  = (optional) int for offsetting returned search results
    # Return:
    #   an array of hashes
    def self.all(fields = nil, filters = nil, order = nil, limit = nil, offset = nil)
      url = "#{@@base_url}/#{@path}/?fields="
      url += fields || @defualt_fields
      url += generate_filters(filters) if filters
      url += "&order="
      url += order || @order
      url += "&limit=#{limit}" if limit
      url += "&offset=#{offset}" if offset
      HTTParty.get(url, headers: @@headers).parsed_response
    end

    # Find exact * from IGDB using it's IGDB id
    # Params:
    #   id     = int that is an IGDB id
    #   fields = (optional) string of fields separated by commas
    # Return:
    #   an array of one hash
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
