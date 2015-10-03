require 'test_helper'

class PeoplePeriodsControllerTest < ActionController::TestCase
  setup do
    @people_period = people_periods(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:people_periods)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create people_period" do
    assert_difference('PeoplePeriod.count') do
      post :create, people_period: { periods_id: @people_period.periods_id, person_id: @people_period.person_id }
    end

    assert_redirected_to people_period_path(assigns(:people_period))
  end

  test "should show people_period" do
    get :show, id: @people_period
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @people_period
    assert_response :success
  end

  test "should update people_period" do
    patch :update, id: @people_period, people_period: { periods_id: @people_period.periods_id, person_id: @people_period.person_id }
    assert_redirected_to people_period_path(assigns(:people_period))
  end

  test "should destroy people_period" do
    assert_difference('PeoplePeriod.count', -1) do
      delete :destroy, id: @people_period
    end

    assert_redirected_to people_periods_path
  end
end
