class Admin::GamesController < AdminController
  def index
    @games = Game.paginate(page: params[:page], per_page: 10).order(:id)
    render layout: false
  end
end
