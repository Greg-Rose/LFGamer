class RegistrationsController < Devise::RegistrationsController
  prepend_before_action :authenticate_scope!, only: [:edit, :update, :delete, :destroy]

  def delete
    render :delete
  end

  protected

  def after_update_path_for(resource)
    edit_user_registration_path(resource)
  end
end
