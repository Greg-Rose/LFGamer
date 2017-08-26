class Admin::LfgsController < AdminController
  def index
    @lfgs = Lfg.paginate(page: params[:page], per_page: 10).order(:id)
    render layout: false
  end
end
