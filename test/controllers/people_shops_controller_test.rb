require 'test_helper'

class PeopleShopsControllerTest < ActionController::TestCase
  setup do
    @people_shop = people_shops(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:people_shops)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create people_shop" do
    assert_difference('PeopleShop.count') do
      post :create, people_shop: { person_id: @people_shop.person_id, shop_id: @people_shop.shop_id }
    end

    assert_redirected_to people_shop_path(assigns(:people_shop))
  end

  test "should show people_shop" do
    get :show, id: @people_shop
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @people_shop
    assert_response :success
  end

  test "should update people_shop" do
    patch :update, id: @people_shop, people_shop: { person_id: @people_shop.person_id, shop_id: @people_shop.shop_id }
    assert_redirected_to people_shop_path(assigns(:people_shop))
  end

  test "should destroy people_shop" do
    assert_difference('PeopleShop.count', -1) do
      delete :destroy, id: @people_shop
    end

    assert_redirected_to people_shops_path
  end
end
