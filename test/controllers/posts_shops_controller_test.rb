require 'test_helper'

class PostsShopsControllerTest < ActionController::TestCase
  setup do
    @posts_shop = posts_shops(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts_shops)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create posts_shop" do
    assert_difference('PostsShop.count') do
      post :create, posts_shop: { post_id: @posts_shop.post_id, shop_id: @posts_shop.shop_id }
    end

    assert_redirected_to posts_shop_path(assigns(:posts_shop))
  end

  test "should show posts_shop" do
    get :show, id: @posts_shop
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @posts_shop
    assert_response :success
  end

  test "should update posts_shop" do
    patch :update, id: @posts_shop, posts_shop: { post_id: @posts_shop.post_id, shop_id: @posts_shop.shop_id }
    assert_redirected_to posts_shop_path(assigns(:posts_shop))
  end

  test "should destroy posts_shop" do
    assert_difference('PostsShop.count', -1) do
      delete :destroy, id: @posts_shop
    end

    assert_redirected_to posts_shops_path
  end
end
