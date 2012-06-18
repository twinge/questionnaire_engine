require 'test_helper'

module Qe
  class JoshesControllerTest < ActionController::TestCase
    setup do
      @josh = joshes(:one)
    end
  
    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:joshes)
    end
  
    test "should get new" do
      get :new
      assert_response :success
    end
  
    test "should create josh" do
      assert_difference('Josh.count') do
        post :create, josh: { name: @josh.name }
      end
  
      assert_redirected_to josh_path(assigns(:josh))
    end
  
    test "should show josh" do
      get :show, id: @josh
      assert_response :success
    end
  
    test "should get edit" do
      get :edit, id: @josh
      assert_response :success
    end
  
    test "should update josh" do
      put :update, id: @josh, josh: { name: @josh.name }
      assert_redirected_to josh_path(assigns(:josh))
    end
  
    test "should destroy josh" do
      assert_difference('Josh.count', -1) do
        delete :destroy, id: @josh
      end
  
      assert_redirected_to joshes_path
    end
  end
end
