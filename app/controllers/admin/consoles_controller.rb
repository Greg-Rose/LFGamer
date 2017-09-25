class Admin::ConsolesController < AdminController
  def index
    @consoles = Console.paginate(page: params[:page], per_page: 10).order(:id)
    render layout: false
  end

  def new
    render layout: false
  end
end
