class ApiPeopleController < ApplicationController

    # GET /api_people/people
    # GET /api_people/people.json
    def people
      @people = Person.all
      respond_to do |format|
        format.html {}
        format.json { render json: @people }
      end
    end

end
