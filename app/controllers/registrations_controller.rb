class RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, :only => [ :cancel]
  prepend_before_filter :authenticate_scope!, :only => [:new, :create ,:edit, :update, :destroy]

  # アカウント作成時に強制的にログインさせないようにする
  def sign_up(resource_name, resource)
    menu_index_path
  end

  # アカウント作成時のリダイレクト先
  def after_sign_up_path_for(resource)
    menu_index_path
  end
end
