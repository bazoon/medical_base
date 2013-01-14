require 'test_helper'

class Inspections::NeurologistsControllerTest < ActionController::TestCase
  setup do
    @inspections_neurologist = inspections_neurologists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:inspections_neurologists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create inspections_neurologist" do
    assert_difference('Inspections::Neurologist.count') do
      post :create, inspections_neurologist: @inspections_neurologist.attributes
    end

    assert_redirected_to inspections_neurologist_path(assigns(:inspections_neurologist))
  end

  test "should show inspections_neurologist" do
    get :show, id: @inspections_neurologist
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @inspections_neurologist
    assert_response :success
  end

  test "should update inspections_neurologist" do
    put :update, id: @inspections_neurologist, inspections_neurologist: @inspections_neurologist.attributes
    assert_redirected_to inspections_neurologist_path(assigns(:inspections_neurologist))
  end

  test "should destroy inspections_neurologist" do
    assert_difference('Inspections::Neurologist.count', -1) do
      delete :destroy, id: @inspections_neurologist
    end

    assert_redirected_to inspections_neurologists_path
  end
end
