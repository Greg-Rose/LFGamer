class Admin::OwnershipsController < AdminController
  def index
    @ownerships = Ownership.paginate(page: params[:page], per_page: 10).order(:id)
    render layout: false
  end
end
