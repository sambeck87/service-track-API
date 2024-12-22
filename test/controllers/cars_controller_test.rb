require "test_helper"
require 'jwt'


class CarsControllerTest < ActionDispatch::IntegrationTest
  setup do
    user = User.create!(
      email: "user@example.com",
      password: "password",
      password_confirmation: "password"
    )
    payload = { user_id: user.id, exp: Time.now.to_i + 3600 }
    secret = Rails.application.secrets.secret_key_base
    @token = JWT.encode(payload, secret)

    @cars = []
    5.times do |i|
      car = Car.create!(plate_number:"XYZ-283#{i}-A" , model: "Sentra" , year:2020)
      @cars << car
    end
  end

  # index CarController Tests
  test "should display a list of cars" do
    get api_v1_cars_url, headers: { 'Authorization' => "Bearer #{@token}" }, as: :json

    assert_response :success

    car_response = JSON.parse(response.body)
    assert_equal 5, car_response["cars"].count
    response_first_car = car_response["cars"][0]
    db_car = @cars[0]
    assert_equal db_car.id, response_first_car["id"]
    assert_equal db_car.plate_number, response_first_car["plate_number"]
    assert_equal db_car.model, response_first_car["model"]
    assert_equal db_car.year, response_first_car["year"]
  end

  test "should have a token to display the car list" do
    get api_v1_cars_url, as: :json

    assert_response :unauthorized

    car_response = JSON.parse(response.body)

    assert_equal "Missing token", car_response["error"]
  end

  test "in index, token should be valid" do
    token = "fake_token"
    get api_v1_cars_url, headers: { 'Authorization' => "Bearer #{token}" }, as: :json

    assert_response :unauthorized

    car_response = JSON.parse(response.body)

    assert_equal "Unauthorized", car_response["error"]
  end


  # show CarController Tests
  test "the car_id should exist" do
    get api_v1_car_url(@cars.last.id + 100), headers: { 'Authorization' => "Bearer #{@token}" }, as: :json

    assert_response :not_found
  end

  test "should display the selected car" do
    get api_v1_car_url(@cars.last.id), headers: { 'Authorization' => "Bearer #{@token}" }, as: :json

    assert_response :success

    car_response = JSON.parse(response.body)

    db_car = @cars.last
    response_car = car_response["car"]

    assert_equal db_car.id, response_car["id"]
    assert_equal db_car.plate_number, response_car["plate_number"]
    assert_equal db_car.model, response_car["model"]
    assert_equal db_car.year, response_car["year"]
  end

  test "in show, token should be valid" do
    token = "fake_token"
    get api_v1_car_url(@cars.last.id), headers: { 'Authorization' => "Bearer #{token}" }, as: :json

    assert_response :unauthorized

    car_response = JSON.parse(response.body)

    assert_equal "Unauthorized", car_response["error"]
  end


  # Create CarController test
  test "in create, token should be valid" do
    token = "fake_token"
    post api_v1_cars_url, headers: { 'Authorization' => "Bearer #{token}" }, as: :json

    assert_response :unauthorized

    car_response = JSON.parse(response.body)

    assert_equal "Unauthorized", car_response["error"]
  end

  test "should create a Car" do
    assert_equal 5, Car.all.count

    post api_v1_cars_url,
      headers: { 'Authorization' => "Bearer #{@token}" },
      params: { car: { plate_number: "YJS-666-A", model: "Accord", year: 2020 } },
      as: :json

    assert_response :success

    car_response = JSON.parse(response.body)

    assert_equal "YJS-666-A", car_response["car"]["plate_number"]
    assert_equal "Accord", car_response["car"]["model"]
    assert_equal 2020, car_response["car"]["year"]
    assert_equal 6, Car.all.count
  end

  test "plate_number should uniq" do
    Car.create!(plate_number: "YJS-666-A", model: "Accord", year: 2024)

    post api_v1_cars_url,
      headers: { 'Authorization' => "Bearer #{@token}" },
      params: { car: { plate_number: "YJS-666-A", model: "Accord", year: 2020 } },
      as: :json

    assert_response :unprocessable_entity

    car_response = JSON.parse(response.body)

    assert_equal "Validation failed: Plate number has already been taken", car_response
  end

  test "year should be present" do
    post api_v1_cars_url,
      headers: { 'Authorization' => "Bearer #{@token}" },
      params: { car: { plate_number: "YJS-666-A", model: "Accord", year: "" } },
      as: :json

    assert_response :unprocessable_entity

    car_response = JSON.parse(response.body)

    assert_equal "Validation failed: Year can't be blank, Year must be between 1900 and current year", car_response
  end

  test "year should be between 1900 and current year" do
    post api_v1_cars_url,
      headers: { 'Authorization' => "Bearer #{@token}" },
      params: { car: { plate_number: "YJS-666-A", model: "Accord", year: "1899" } },
      as: :json

    assert_response :unprocessable_entity

    car_response = JSON.parse(response.body)

    assert_equal "Validation failed: Year must be between 1900 and current year", car_response

    post api_v1_cars_url,
    headers: { 'Authorization' => "Bearer #{@token}" },
    params: { car: { plate_number: "YJS-666-A", model: "Accord", year: Date.today.year + 1 } },
    as: :json

    assert_response :unprocessable_entity

    car_response = JSON.parse(response.body)

    assert_equal "Validation failed: Year must be between 1900 and current year", car_response
  end

  # update CarController test
  test "in update, token should be valid" do
    token = "fake_token"
    put api_v1_car_url(@cars[0].id), headers: { 'Authorization' => "Bearer #{token}" }, as: :json

    assert_response :unauthorized

    car_response = JSON.parse(response.body)

    assert_equal "Unauthorized", car_response["error"]
  end

  test "the car_id should exist to update it" do
    put api_v1_car_url(@cars.last.id + 100), headers: { 'Authorization' => "Bearer #{@token}" }, as: :json

    assert_response :not_found
  end

  test "should update the selected car" do
    put api_v1_car_url(@cars[0].id),
      headers: { 'Authorization' => "Bearer #{@token}" }, as: :json,
      params: { car: { plate_number: "YJS-111-Z", model: "Ford Fiesta", year: 2010 } },
      as: :json

    assert_response :success

    car_response = JSON.parse(response.body)

    db_car = Car.find(@cars[0].id)
    response_car = car_response["car"]

    assert_equal db_car.plate_number, response_car["plate_number"]
    assert_equal db_car.model, response_car["model"]
    assert_equal db_car.year, response_car["year"]
  end


  # destroy CarController test
  test "in delete, token should be valid" do
    token = "fake_token"
    delete api_v1_car_url(@cars[0].id), headers: { 'Authorization' => "Bearer #{token}" }, as: :json

    assert_response :unauthorized

    car_response = JSON.parse(response.body)

    assert_equal "Unauthorized", car_response["error"]
  end

  test "the car_id should exist to delete it" do
    delete api_v1_car_url(@cars.last.id + 100), headers: { 'Authorization' => "Bearer #{@token}" }, as: :json

    assert_response :not_found
  end

  test "should be delete it" do
    assert_equal 5, Car.all.count

    delete api_v1_car_url(@cars.last.id), headers: { 'Authorization' => "Bearer #{@token}" }, as: :json

    assert_response :no_content

    assert_equal 4, Car.all.count
  end
end
