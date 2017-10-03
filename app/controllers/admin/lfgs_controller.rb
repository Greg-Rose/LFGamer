class Admin::LfgsController < AdminController
  layout false

  def index
    @lfgs = Lfg.paginate(page: params[:page], per_page: 10).order(:id)
  end
end
