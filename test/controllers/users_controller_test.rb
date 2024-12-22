require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should create an User" do
    post api_v1_users_url, params: {
      user: {
        email: "user@example.com",
        password: "password",
        password_confirmation: "password"
      }
    }, as: :json

    assert_response :success

    user_response = JSON.parse(response.body)
    assert_equal "User created successfully", user_response["message"]
  end

  test "email should be valid" do
    post api_v1_users_url, params: {
      user: {
        email: "userexample.com",
        password: "password",
        password_confirmation: "password"
      }
    }, as: :json

    assert_response :unprocessable_entity

    user_response = JSON.parse(response.body)
    assert_equal "User creation failed", user_response["error"]
    assert_equal "Email is not a valid email address", user_response["details"][0]
  end

  test "email should be present" do
    post api_v1_users_url, params: {
      user: {
        email: "",
        password: "password",
        password_confirmation: "password"
      }
    }, as: :json

    assert_response :unprocessable_entity

    user_response = JSON.parse(response.body)
    assert_equal "User creation failed", user_response["error"]
    assert_equal "Email can't be blank", user_response["details"][0]
  end

  test "password should be present" do
    post api_v1_users_url, params: {
      user: {
        email: "user@example.com",
        password: "",
        password_confirmation: "password"
      }
    }, as: :json

    assert_response :unprocessable_entity

    user_response = JSON.parse(response.body)
    assert_equal "User creation failed", user_response["error"]
    assert_equal "Password can't be blank", user_response["details"][0]
  end

  test "password and password_confirmation should be equal" do
    post api_v1_users_url, params: {
      user: {
        email: "user@example.com",
        password: "password",
        password_confirmation: "pasword"
      }
    }, as: :json

    assert_response :unprocessable_entity

    user_response = JSON.parse(response.body)
    assert_equal "User creation failed", user_response["error"]
    assert_equal "Password confirmation doesn't match Password", user_response["details"][0]
  end
end
