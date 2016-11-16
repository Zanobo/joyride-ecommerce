require 'test_helper'

class AccountCreateFlowTest < ActionDispatch::IntegrationTest

  test "can create a user" do
    get "/signup"
    assert_response :success

    post "/signup",
         params: { spree_user: { email: "test@example.com", company_name: "Test Company", first_name: "Zach",
                  last_name: "Risher", password: "password"} }
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end
end
