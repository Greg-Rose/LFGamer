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
    @searched_games = IGDB::Game.search(search, nil, ["[cover.cloudinary_id][exists]"])
    render layout: false
  end
end
