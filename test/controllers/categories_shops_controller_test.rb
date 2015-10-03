require 'test_helper'

class CategoriesShopsControllerTest < ActionController::TestCase
  setup do
    @categories_shop = categories_shops(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:categories_shops)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create categories_shop" do
    assert_difference('CategoriesShop.count') do
      post :create, categories_shop: { category_id: @categories_shop.category_id, shop_id: @categories_shop.shop_id }
    end

    assert_redirected_to categories_shop_path(assigns(:categories_shop))
  end

  test "should show categories_shop" do
    get :show, id: @categories_shop
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @categories_shop
    assert_response :success
  end

  test "should update categories_shop" do
    patch :update, id: @categories_shop, categories_shop: { category_id: @categories_shop.category_id, shop_id: @categories_shop.shop_id }
    assert_redirected_to categories_shop_path(assigns(:categories_shop))
  end

  test "should destroy categories_shop" do
    assert_difference('CategoriesShop.count', -1) do
      delete :destroy, id: @categories_shop
    end

    assert_redirected_to categories_shops_path
  end
end
