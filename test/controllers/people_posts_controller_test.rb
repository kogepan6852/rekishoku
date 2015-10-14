require 'test_helper'

class PeoplePostsControllerTest < ActionController::TestCase
  setup do
    @people_post = people_posts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:people_posts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create people_post" do
    assert_difference('PeoplePost.count') do
      post :create, people_post: { person_id: @people_post.person_id, post_id: @people_post.post_id }
    end

    assert_redirected_to people_post_path(assigns(:people_post))
  end

  test "should show people_post" do
    get :show, id: @people_post
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @people_post
    assert_response :success
  end

  test "should update people_post" do
    patch :update, id: @people_post, people_post: { person_id: @people_post.person_id, post_id: @people_post.post_id }
    assert_redirected_to people_post_path(assigns(:people_post))
  end

  test "should destroy people_post" do
    assert_difference('PeoplePost.count', -1) do
      delete :destroy, id: @people_post
    end

    assert_redirected_to people_posts_path
  end
end
