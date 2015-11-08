class MenuController < ApplicationController
  before_filter :authenticate_user!
# GET /index
  def index
  end

  def show
  end

  def new
  end
end
