require File.dirname(__FILE__) + '/../test_helper'

class CommitsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:commits)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_commit
    assert_difference('Commit.count') do
      post :create, :commit => { }
    end

    assert_redirected_to commit_path(assigns(:commit))
  end

  def test_should_show_commit
    get :show, :id => commits(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => commits(:one).id
    assert_response :success
  end

  def test_should_update_commit
    put :update, :id => commits(:one).id, :commit => { }
    assert_redirected_to commit_path(assigns(:commit))
  end

  def test_should_destroy_commit
    assert_difference('Commit.count', -1) do
      delete :destroy, :id => commits(:one).id
    end

    assert_redirected_to commits_path
  end
end
