class Admin::OwnershipsController < AdminController
  layout false

  def index
    @ownerships = Ownership.paginate(page: params[:page], per_page: 10).order(:id)
  end
end
