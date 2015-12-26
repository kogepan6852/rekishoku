class ApiPeopleController < ApplicationController

    # GET /api/people
    # GET /api/people.json
    def people
      @people = Person.all
      respond_to do |format|
        format.html {}
        format.json { render json: @people }
      end
    end

    # GET /api/periods
    # GET /api/periods_api.json
    def periods
      @periods = Period.all
    end


end
