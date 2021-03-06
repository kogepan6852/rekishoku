class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  # Stagingの場合はベーシック認証を設定
  http_basic_authenticate_with :name => ENV['BASIC_AUTH_USERNAME'], :password => ENV['BASIC_AUTH_PASSWORD'] if Rails.env == "staging" && ENV['BASIC_AUTH_USERNAME']

  # json でのリクエストの場合CSRFトークンの検証をスキップ
  skip_before_action :verify_authenticity_token,     if: -> {request.format.json?}
  # トークンによる認証
  before_action      :authenticate_user_from_token!, if: -> {params[:email].present?}

  # 権限無しのリソースにアクセスしようとした場合
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to main_app.root_url, alert: exception.message }
      format.json { render json: {message: exception.message}, status: :unauthorized }
    end
  end

  # SSL
  if Rails.env.production?
    force_ssl if: :force_ssl?
  end

  # トークンによる認証
  def authenticate_user_from_token!
    user = User.find_by(email: params[:email])
    if Devise.secure_compare(user.try(:authentication_token), params[:token])
      sign_in user, store: false
    else
      sign_out user
      render json: { "error" => I18n.t('devise.failure.timeout') }, :status => 401
    end
  end

  private
    def force_ssl?
      not request.path =~ /^.well-known\/acme-challenge/
    end

end
