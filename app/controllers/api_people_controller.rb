class ApiPeopleController < ApplicationController

  # GET /api/people
  # 一覧表示
  def index
    @people = Person.all
    # カテゴリーで検索
    if params[:category]
      @people = @people.joins(:categories).where('categories_people.category_id = ?', params[:category].to_i)
    end

    people = Array.new()
    @people.each do |person|
      if person[:rating] != 0.0
        people.push(person)
      end
    end
    render json: people
  end

  # GET /api/people-list
  # post-list用一覧表示
  def list
    @people = Person.all
    people = Array.new()
    @people.each do |person|
      # 対象のpostが紐付いているかチェック
      hasPost = false
      person.stories.each do |post|
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
