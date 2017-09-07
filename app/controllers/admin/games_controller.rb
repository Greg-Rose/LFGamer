class Admin::GamesController < AdminController
  def index
    @games = Game.paginate(page: params[:page], per_page: 10).order(:id)
    render layout: false
  end

  def new
    search = params["search"]
    @searched_games = IGDB::Game.search(search) if search
    render layout: false
  end
end
