require "test_helper"

class IndividualTicketsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get individual_tickets_create_url
    assert_response :success
  end

  test "should get show" do
    get individual_tickets_show_url
    assert_response :success
  end

  test "should get index" do
    get individual_tickets_index_url
    assert_response :success
  end

  test "should get edit" do
    get individual_tickets_edit_url
    assert_response :success
  end

  test "should get update" do
    get individual_tickets_update_url
    assert_response :success
  end

  test "should get transfer" do
    get individual_tickets_transfer_url
    assert_response :success
  end
end
