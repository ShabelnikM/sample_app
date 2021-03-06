class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    auth_info = request.env.dig 'omniauth.auth', 'extra', 'raw_info'
    redirect_to root_path, flash: {error: 'Error from FaceBook!' } and return unless auth_info
    @user = User.find_user_by_oauth uid: auth_info['id'], provider: 'facebook'
    if @user.present?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else @user = User.find_by(email: auth_info['email'])
      if @user.present?
        @user.oauths.create uid: auth_info['id'], provider: 'facebook', link: auth_info['link']
        sign_in_and_redirect @user
        set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
      else
        redirect_to new_user_registration_url user_info: {uid: auth_info['id'],
                                                          provider: 'facebook',
                                                          name: auth_info['name'],
                                                          email: auth_info['email'],
                                                          link: auth_info['link']}
      end
    end
  end

  def google_oauth2
    auth_info = request.env.dig 'omniauth.auth', 'extra', 'raw_info'
    redirect_to root_path, flash: {error: 'Error from Google!' } and return unless auth_info
    @user = User.find_user_by_oauth uid: auth_info['sub'], provider: 'google_oauth2'
    if @user.present?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
    else @user = User.find_by(email: auth_info['email'])
    if @user.present?
      @user.oauths.create uid: auth_info['sub'], provider: 'google_oauth2', link: auth_info['profile']
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
    else
      redirect_to new_user_registration_url user_info: {uid: auth_info['sub'],
                                                        provider: 'google_oauth2',
                                                        name: auth_info['name'],
                                                        email: auth_info['email'],
                                                        link: auth_info['profile']}
    end
    end
  end

  def vk
    auth_raw_info = request.env.dig 'omniauth.auth', 'extra', 'raw_info'
    auth_info = request.env.dig 'omniauth.auth', 'info'
    redirect_to root_path, flash: {error: 'Error from Vk!' } and return unless auth_info
    @user = User.find_user_by_oauth uid: auth_raw_info['id'], provider: 'vk'
    if @user.present?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: 'Vk') if is_navigational_format?
    elsif current_user.present?
      user = current_user
      user.oauths.create uid: auth_raw_info['id'], provider: 'vk', link: "https://vk.com/id#{auth_info['user_id']}"
      sign_in_and_redirect user
      set_flash_message(:notice, :success, kind: 'Vk') if is_navigational_format?
    else
      redirect_to new_user_registration_url user_info: {uid: auth_raw_info['id'],
                                                        provider: 'vk',
                                                        name: auth_info['name'],
                                                        link: "https://vk.com/id#{auth_info['user_id']}"}
    end
  end

  def twitter
    auth_info = request.env.dig 'omniauth.auth', 'extra', 'raw_info'
    link_url = request.env.dig 'omniauth.auth', 'info', 'urls', 'Twitter'
    redirect_to root_path, flash: {error: 'Error from Twitter!' } and return unless auth_info
    @user = User.find_user_by_oauth uid: auth_info['id'], provider: 'twitter'
    if @user.present?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    elsif current_user.present?
      user = current_user
      user.oauths.create uid: auth_info['id'], provider: 'twitter', link: link_url
      sign_in_and_redirect user
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    else
      redirect_to new_user_registration_url user_info: {uid: auth_info['id'],
                                                        provider: 'twitter',
                                                        name: auth_info['name'],
                                                        link: link_url}
    end
  end

  def failure
    redirect_to root_path
  end
end