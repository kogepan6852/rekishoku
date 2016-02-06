class RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, :only => [ :cancel]
  prepend_before_filter :authenticate_scope!, :only => [:new, :create ,:edit, :update, :destroy]

  def after_sign_up_path_for(resource)
    menu_index_path
  end

  def after_inactive_sign_up_path_for(resource)
    menu_index_path
  end
end
