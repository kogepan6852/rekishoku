class ApiPeriodController < ApplicationController
  # GET /api_period/periods
  # GET /api_period/periods.json
  def periods
    @periods = Period.all
  end
end
