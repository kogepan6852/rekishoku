require 'koala'

class Users::SnsAuthController < ApplicationController
  # GET /facebook
  def facebook
    # get facebook info
    fb = Koala::Facebook::API.new(params[:token], Rails.configuration.facebook_app_secret)
    response = fb.get_object("me")

    if response['id'] == params[:uid]
      # create pr update user
      user = User.find_for_oauth(params[:uid], "facebook", params[:fbmail])
      if user
        sign_in user, store: false

        rtn = {
          "id" => user.id,
          "email" => user.email,
          "role" => user.role,
          "authentication_token" => user.ensure_authentication_token
        }
      else
        rtn = { "error" => I18n.t('errors.messages.not_saved.one') }
      end
    else
      rtn = { "error" => I18n.t('errors.messages.not_saved.one') }
    end
    render json: rtn
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def sns_auth_params
      params.require(:sns_auth).permit(:token, :uid, :provider, :fbmail)
    end

end
