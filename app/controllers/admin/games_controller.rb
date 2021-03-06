class Admin::GamesController < AdminController
  layout false

  def index
    @games = Game.paginate(page: params[:page], per_page: 10).order(:id)
  end

  def new
  end

  def create
    game = IGDB::Game.find(params[:id]).first
    PropagateDatabase.add_game(game)
    render json: :nothing, status: :created
  end

  def search
    search = params["search"]
    @searched_games = IGDB::Game.search(search, nil, ["[cover.cloudinary_id][exists]", "[release_dates.platform][exists]", "[category][eq]=0"])
    # Use until IGDB API fixes filter by multiple platforms via [release_dates.platform] with [any] postfix
    @searched_games.select! do |game|
      valid_console = false
      Console.all.each do |c|
        game["release_dates"].each do |rd|
          if rd["platform"] == c.igdb_id
            valid_console = true
            break
          end
        end
      end
      next valid_console
    end
  end
end
