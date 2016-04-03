class ApiPeriodsController < ApplicationController
  # GET /periods
  def index
    @periods = Period.all
    periods = Array.new()
    @periods.each do |period|
      obj = {
        "id" => period.id,
        "name" => period.name
      }
      periods.push(obj)
    end
    render json: periods
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def period_params
      params.require(:period).permit(:id)
    end
end
