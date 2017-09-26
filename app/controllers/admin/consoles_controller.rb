class Admin::ConsolesController < AdminController
  def index
    @consoles = Console.paginate(page: params[:page], per_page: 10).order(:id)
    render layout: false
  end

  def new
    render layout: false
  end

  def create
    name = params[:name]
    abbreviation = params[:abbreviation]
    abbreviation = nil if abbreviation.blank?
    console = [name, abbreviation]
    PropagateDatabase.add_console(console)
    render json: :nothing, status: :created
  end

  def search
    search = params["search"]
    @searched_console = IGDB::Platform.search(search).first
    if @searched_console
      @already_added = true if Console.find_by(name: @searched_console["name"])
    end

    render layout: false
  end
end
