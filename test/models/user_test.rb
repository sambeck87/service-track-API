require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should be valid" do
    user = User.new(
      email: "correo_valido@gmail.com",
      password: "password",
      password_confirmation: "password"
    )
    assert user.valid?
  end

  test "email should be present" do
    user = User.new(
      email: "",
      password: "password",
      password_confirmation: "password"
    )
    assert_not user.valid?
  end

  test "password should be present" do
    user = User.new(
      email: "correo_valido@gmail.com",
      password: "",
      password_confirmation: "password"
    )
    assert_not user.valid?
  end

  test "should have a valid email structure" do
    user = User.new(
      email: "correonovalido",
      password: "password",
      password_confirmation: "password"
    )
    assert_not user.valid?
  end

  test "password and password_confirmatons should be equals" do
    user = User.new(
      email: "correonovalido",
      password: "password",
      password_confirmation: "passwordd"
    )
    assert_not user.valid?
  end

  test "email should be uniq" do
    user = User.create!(
      email: "correo_valido@gmail.com",
      password: "password",
      password_confirmation: "password"
    )

    user = User.new(
      email: "correo_valido@gmail.com",
      password: "password",
      password_confirmation: "password"
    )
    assert_not user.valid?
  end
end
