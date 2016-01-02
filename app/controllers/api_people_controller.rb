class ApiPeopleController < ApplicationController

  # GET /api/people
  def index
    @people = Person.all
    render json: @people
  end

  # GET /api/people-list
  def list
    @people = Person.all
    people = Array.new()
    @people.each do |person|
      # 対象のpostが紐付いているかチェック
      hasPost = false
      person.posts.each do |post|
        if post.id == params[:post_id].to_i
          hasPost = true
        end
      end
      obj = { "id" => person.id, "name" => person.name, "hasPost" => hasPost}
      people.push(obj);
    end
    render json: people
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:name, :furigana, :id, :period_ids => [], :category_ids => [])
    end

end
