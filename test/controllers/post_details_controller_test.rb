require 'test_helper'

class PostDetailsControllerTest < ActionController::TestCase
  setup do
    @post_detail = post_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:post_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create post_detail" do
    assert_difference('PostDetail.count') do
      post :create, post_detail: { content: @post_detail.content, image: @post_detail.image, post_id: @post_detail.post_id, quotation_name: @post_detail.quotation_name, quotation_url: @post_detail.quotation_url, title: @post_detail.title }
    end

    assert_redirected_to post_detail_path(assigns(:post_detail))
  end

  test "should show post_detail" do
    get :show, id: @post_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @post_detail
    assert_response :success
  end

  test "should update post_detail" do
    patch :update, id: @post_detail, post_detail: { content: @post_detail.content, image: @post_detail.image, post_id: @post_detail.post_id, quotation_name: @post_detail.quotation_name, quotation_url: @post_detail.quotation_url, title: @post_detail.title }
    assert_redirected_to post_detail_path(assigns(:post_detail))
  end

  test "should destroy post_detail" do
    assert_difference('PostDetail.count', -1) do
      delete :destroy, id: @post_detail
    end

    assert_redirected_to post_details_path
  end
end
