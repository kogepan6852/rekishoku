class AppRouteController < ApplicationController
  before_action :set_params, only: [:post, :shop]

  # 詳細データ表示
  def show
    path = Rails.root.to_s + "/public/main.html"
    render :file => path, :layout => false
  end

  # ssl証明書発行用
  def letsencrypt
    if params[:id] == ENV["LETSENCRYPT_REQUEST"]
    render text: ENV["LETSENCRYPT_RESPONSE"]
    end
  end

end
