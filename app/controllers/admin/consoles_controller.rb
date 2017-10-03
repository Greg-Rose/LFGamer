class Admin::ConsolesController < AdminController
  layout false

  def index
    @consoles = Console.paginate(page: params[:page], per_page: 10).order(:id)
  end

  def new
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
  end
end
