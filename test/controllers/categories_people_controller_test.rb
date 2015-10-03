require 'test_helper'

class CategoriesPeopleControllerTest < ActionController::TestCase
  setup do
    @categories_person = categories_people(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:categories_people)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create categories_person" do
    assert_difference('CategoriesPerson.count') do
      post :create, categories_person: { category_id: @categories_person.category_id, person_id: @categories_person.person_id }
    end

    assert_redirected_to categories_person_path(assigns(:categories_person))
  end

  test "should show categories_person" do
    get :show, id: @categories_person
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @categories_person
    assert_response :success
  end

  test "should update categories_person" do
    patch :update, id: @categories_person, categories_person: { category_id: @categories_person.category_id, person_id: @categories_person.person_id }
    assert_redirected_to categories_person_path(assigns(:categories_person))
  end

  test "should destroy categories_person" do
    assert_difference('CategoriesPerson.count', -1) do
      delete :destroy, id: @categories_person
    end

    assert_redirected_to categories_people_path
  end
end
