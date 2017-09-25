class Admin::ConsolesController < AdminController
  def index
    @consoles = Console.paginate(page: params[:page], per_page: 10).order(:id)
    render layout: false
  end

  def new
    render layout: false
  end

  def search
    search = params["search"]
    @searched_console = IGDB::Platform.search(search).first["name"]

    render layout: false
  end
end
