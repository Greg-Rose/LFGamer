class RegistrationsController < Devise::RegistrationsController
  prepend_before_action :authenticate_scope!, only: [:edit, :update, :delete, :destroy]

  def delete
    render :delete
  end

  def destroy
    if resource.soft_delete_with_password(delete_params)
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      set_flash_message :notice, :destroyed if is_flashing_format?
      yield resource if block_given?
      respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
    else
      render :delete
    end
  end

  protected

  def after_sign_up_path_for(resource)
    edit_profile_path
  end

  def after_update_path_for(resource)
    edit_user_registration_path(resource)
  end

  def delete_params
    params.require(:user).permit(:current_password)
  end
end
