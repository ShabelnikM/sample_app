class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_user, only: [:facebook, :twitter]

  def facebook
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      session['devise.facebook_data'] = request.env['omniauth.auth']
      flash[:notice] = 'Current email already was registered'
      redirect_to new_user_registration_url
    end
  end

  def twitter
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    else
      session['devise.twitter_data'] = request.env['omniauth.auth'].delete_if('extra')
      flash[:notice] = 'Current email already was registered'
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end

  private
  def set_user
    @user = User.from_omniauth(request.env['omniauth.auth'])
  end
end