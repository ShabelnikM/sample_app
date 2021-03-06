class ApplicationController < ActionController::Base
  include CanCan::ControllerAdditions

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role, :confirmed_at, oauths_attributes: [:uid, :provider, :link] ])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :role])
  end
end

