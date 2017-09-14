class Admin::GamesController < AdminController
  def index
    @games = Game.paginate(page: params[:page], per_page: 10).order(:id)
    render layout: false
  end

  def new
    render layout: false
  end

  def search
    search = params["search"]
    @searched_games = IGDB::Game.search(search, nil, ["[cover.cloudinary_id][exists]", "[release_dates.platform][exists]", "[category][eq]=0"])
    # remove/replace once IGDB API fixes multiple consoles filter with [any] for games
    # *** BROKEN - MAKES TOO MANY REQUESTS TO API ***
    # @searched_games.select! do |game|
    #   valid_console = false
    #   Console.all.each do |console|
    #     api_id = IGDB::Platform.search(console.name).first["id"]
    #     game["release_dates"].each do |rd|
    #       if rd["platform"] == api_id
    #         valid_console = true
    #         break
    #       end
    #     end
    #   end
    #
    #   next valid_console
    # end
    # ^end remove after...^
    render layout: false
  end
end
