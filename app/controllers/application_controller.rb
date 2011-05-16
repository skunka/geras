class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all

  ActiveScaffold.set_defaults do |config|
    config.ignore_columns.add [:created_at, :updated_at, :encrypted_password,:password_salt,:reset_password_token,:remember_token,:remember_created_at,:sign_in_count,
      :current_sign_in_at,:last_sign_in_at,:current_sign_in_ip,:last_sign_in_ip,:confirmation_token,:confirmed_at,:confirmation_sent_at,:reset_password_sent_at]
	config.theme = :blue  
  end

  def accessible_roles
    @accessible_roles = Role.accessible_by(current_ability,:read)
  end


  def get_user
    @current_user = current_user
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end
end
