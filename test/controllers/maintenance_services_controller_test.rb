require "test_helper"

class MaintenanceServicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    user = User.create!(
      email: "user@example.com",
      password: "password",
      password_confirmation: "password"
    )
    payload = { user_id: user.id, exp: Time.now.to_i + 3600 }
    secret = Rails.application.secrets.secret_key_base
    @token = JWT.encode(payload, secret)

    cars = []
    5.times do |i|
      car = Car.create!(id: i + 1, plate_number:"XYZ-283#{i}-A" , model: "Sentra" , year:2020)
      cars << car
    end

    @maintenance_service = []
    30.times do |i|
      maintenance_service = MaintenanceService.create!(
        car_id: (i%5) + 1,
        description: "Afinacion mayor ##{i}",
        status: "pending",
        date: "2024-12-12"
      )
      @maintenance_service << maintenance_service
    end

    30.times do |i|
      maintenance_service = MaintenanceService.create!(
        car_id: (i%5) + 1,
        description: "Afinacion mayor ##{i+30}",
        status: "in_progress",
        date: "2024-12-15"
      )
      @maintenance_service << maintenance_service
    end

    10.times do |i|
      maintenance_service = MaintenanceService.create!(
        car_id: (i%5) + 1,
        description: "Afinacion mayor ##{i+60}",
        status: "completed",
        date: "2024-12-20"
      )
      @maintenance_service << maintenance_service
    end

  end

  # index CarController Tests
  test "should display a list of maintenance_services" do
    get(api_v1_maintenance_services_path,
      headers: { 'Authorization' => "Bearer #{@token}" }
    )

    assert_response :success

    maintenance_service_response = JSON.parse(response.body)
    assert_equal 70, maintenance_service_response["maintenance_services"].count
    response_first_maintenance_service = maintenance_service_response["maintenance_services"][0]
    db_maintenance_service = @maintenance_service[0]
    assert_equal db_maintenance_service.id, response_first_maintenance_service["id"]
    assert_equal db_maintenance_service.car_id, response_first_maintenance_service["car_id"]
    assert_equal db_maintenance_service.description, response_first_maintenance_service["description"]
    assert_equal db_maintenance_service.status, response_first_maintenance_service["status"]
    assert_equal db_maintenance_service.date, Date.parse(response_first_maintenance_service["date"])
  end

  test "should return only the first 10 elements" do
    get(api_v1_maintenance_services_path,
      headers: { 'Authorization' => "Bearer #{@token}" },
      params: { limit: 10, offset: 0 })

    assert_response :success

    maintenance_service_response = JSON.parse(response.body)
    maintenance_service_response = maintenance_service_response["maintenance_services"]
    assert_equal 10, maintenance_service_response.count

    maintenance_services = @maintenance_service.first(10)


    10.times do |i|
      assert_equal maintenance_services[i].id, maintenance_service_response[i]["id"]
    end
  end

  test "should return only the cars with 'pending' status" do
    get(api_v1_maintenance_services_path,
      headers: { 'Authorization' => "Bearer #{@token}" },
      params: { filters: 'status=pending' })

    assert_response :success

    maintenance_service_response = JSON.parse(response.body)
    maintenance_service_response = maintenance_service_response["maintenance_services"]
    assert_equal 30, maintenance_service_response.count

    30.times do |i|
      assert_equal "pending", maintenance_service_response[i]["status"]
    end
  end

  test "should return only the cars with 'in_progress' status" do
    get(api_v1_maintenance_services_path,
      headers: { 'Authorization' => "Bearer #{@token}" },
      params: { filters: 'status=in_progress' })

    assert_response :success

    maintenance_service_response = JSON.parse(response.body)
    maintenance_service_response = maintenance_service_response["maintenance_services"]
    assert_equal 30, maintenance_service_response.count

    30.times do |i|
      assert_equal "in_progress", maintenance_service_response[i]["status"]
    end
  end

  test "should return only the cars with 'completed' status" do
    get(api_v1_maintenance_services_path,
      headers: { 'Authorization' => "Bearer #{@token}" },
      params: { filters: 'status=completed' })

    assert_response :success

    maintenance_service_response = JSON.parse(response.body)
    maintenance_service_response = maintenance_service_response["maintenance_services"]
    assert_equal 10, maintenance_service_response.count

    10.times do |i|
      assert_equal "completed", maintenance_service_response[i]["status"]
    end
  end

  test "should return the car information" do
    get(api_v1_maintenance_services_path,
      headers: { 'Authorization' => "Bearer #{@token}" },
      params: { filters: 'plate_number=XYZ-2830-A', include_fields:'car' })

    assert_response :success

    maintenance_service_response = JSON.parse(response.body)
    maintenance_service_response = maintenance_service_response["maintenance_services"]
    assert_equal 14, maintenance_service_response.count

    assert_equal "XYZ-2830-A", maintenance_service_response[0]["car"]["plate_number"]
    assert_equal "Sentra", maintenance_service_response[0]["car"]["model"]
    assert_equal 2020, maintenance_service_response[0]["car"]["year"]
  end

  test "should return only the cars with XYZ-2830-A plate_number" do
    get(api_v1_maintenance_services_path,
      headers: { 'Authorization' => "Bearer #{@token}" },
      params: { filters: 'plate_number=XYZ-2830-A', include_fields:'car' })

    assert_response :success

    maintenance_service_response = JSON.parse(response.body)
    maintenance_service_response = maintenance_service_response["maintenance_services"]
    assert_equal 14, maintenance_service_response.count

    14.times do |i|
      assert_equal "XYZ-2830-A", maintenance_service_response[i]["car"]["plate_number"]
    end
  end

  test "should return only the cars with XYZ-2830-A plate_number and status completed" do
    get(api_v1_maintenance_services_path,
      headers: { 'Authorization' => "Bearer #{@token}" },
      params: { filters: 'plate_number=XYZ-2830-A;status=completed', include_fields:'car' })

    assert_response :success

    maintenance_service_response = JSON.parse(response.body)
    maintenance_service_response = maintenance_service_response["maintenance_services"]
    assert_equal 2, maintenance_service_response.count

    2.times do |i|
      assert_equal "XYZ-2830-A", maintenance_service_response[i]["car"]["plate_number"]
      assert_equal "completed", maintenance_service_response[i]["status"]
    end
  end

  test "should have a token to display the maintenance_service list" do
    get api_v1_maintenance_services_url, as: :json

    assert_response :unauthorized

    maintenance_service_response = JSON.parse(response.body)

    assert_equal "Missing token", maintenance_service_response["error"]
  end

  test "in index, token should be valid" do
    token = "fake_token"
    get api_v1_maintenance_services_url, headers: { 'Authorization' => "Bearer #{token}" }, as: :json

    assert_response :unauthorized

    maintenance_service_response = JSON.parse(response.body)

    assert_equal "Unauthorized", maintenance_service_response["error"]
  end


  # # show CarController Tests
  test "the maintenance_service_id should exist" do
    get api_v1_maintenance_service_url(@maintenance_service.last.id + 100), headers: { 'Authorization' => "Bearer #{@token}" }, as: :json

    assert_response :not_found
  end

  test "should display the selected maintenance_service" do
    get api_v1_maintenance_service_url(@maintenance_service.last.id), headers: { 'Authorization' => "Bearer #{@token}" }, as: :json

    assert_response :success

    maintenance_service_response = JSON.parse(response.body)

    db_maintenance_service = @maintenance_service.last
    response_maintenance_service = maintenance_service_response["maintenance_service"]

    assert_equal db_maintenance_service.id, response_maintenance_service["id"]
    assert_equal db_maintenance_service.car_id, response_maintenance_service["car_id"]
    assert_equal db_maintenance_service.description, response_maintenance_service["description"]
    assert_equal db_maintenance_service.status, response_maintenance_service["status"]
    assert_equal db_maintenance_service.date, Date.parse(response_maintenance_service["date"])
  end

  test "in show, token should be valid" do
    token = "fake_token"
    get api_v1_maintenance_service_url(@maintenance_service.last.id), headers: { 'Authorization' => "Bearer #{token}" }, as: :json

    assert_response :unauthorized

    maintenance_service_response = JSON.parse(response.body)

    assert_equal "Unauthorized", maintenance_service_response["error"]
  end


  # # Create CarController test
  test "in create, token should be valid" do
    token = "fake_token"
    post api_v1_maintenance_services_url, headers: { 'Authorization' => "Bearer #{token}" }, as: :json

    assert_response :unauthorized

    maintenance_service_response = JSON.parse(response.body)

    assert_equal "Unauthorized", maintenance_service_response["error"]
  end

  test "should create a Car" do
    assert_equal 70, MaintenanceService.all.count

    post api_v1_maintenance_services_url,
      headers: { 'Authorization' => "Bearer #{@token}" },
      params: {
        maintenance_service: {
          car_id: 3,
          description: "cambio de aceite",
          status: "pending",
          date: "1990-12-31"
          }
        },
      as: :json

    assert_response :success

    maintenance_service_response = JSON.parse(response.body)

    assert_equal 3, maintenance_service_response["maintenance_service"]["car_id"]
    assert_equal "cambio de aceite", maintenance_service_response["maintenance_service"]["description"]
    assert_equal "1990-12-31", maintenance_service_response["maintenance_service"]["date"]
    assert_equal 71, MaintenanceService.all.count
  end

  test "description should be present" do
    post api_v1_maintenance_services_url,
      headers: { 'Authorization' => "Bearer #{@token}" },
      params: {
        maintenance_service: {
          car_id: 3,
          description: "",
          status: "pending",
          date: "1990-12-31"
          }
      },
      as: :json

    assert_response :unprocessable_entity

    maintenance_service_response = JSON.parse(response.body)

    assert_equal "Validation failed: Description can't be blank", maintenance_service_response
  end

  test "status should be present" do
    post api_v1_maintenance_services_url,
      headers: { 'Authorization' => "Bearer #{@token}" },
      params: {
        maintenance_service: {
          car_id: 3,
          description: "cambio de aceite",
          status: "",
          date: "1990-12-31"
          }
      },
      as: :json

    assert_response :unprocessable_entity

    maintenance_service_response = JSON.parse(response.body)

    assert_equal "Validation failed: Status can't be blank", maintenance_service_response
  end

  test "date should be present and not exceed the current date" do
    post api_v1_maintenance_services_url,
      headers: { 'Authorization' => "Bearer #{@token}" },
      params: {
        maintenance_service: {
          car_id: 3,
          description: "cambio de aceite",
          status: "pending",
          date: ""
          }
      },
      as: :json

    assert_response :unprocessable_entity

    maintenance_service_response = JSON.parse(response.body)

    assert_equal "Validation failed: Date must not exceed the current year", maintenance_service_response

    post api_v1_maintenance_services_url,
    headers: { 'Authorization' => "Bearer #{@token}" },
    params: {
      maintenance_service: {
        car_id: 3,
        description: "cambio de aceite",
        status: "pending",
        date: Date.today + 1
        }
    },
    as: :json

  assert_response :unprocessable_entity

  maintenance_service_response = JSON.parse(response.body)

  assert_equal "Validation failed: Date must not exceed the current year", maintenance_service_response
  end


  # # update CarController test
  test "in update, token should be valid" do
    token = "fake_token"
    put api_v1_maintenance_service_url(@maintenance_service[0].id), headers: { 'Authorization' => "Bearer #{token}" }, as: :json

    assert_response :unauthorized

    maintenance_service_response = JSON.parse(response.body)

    assert_equal "Unauthorized", maintenance_service_response["error"]
  end

  test "the maintenance_service_id should exist to update it" do
    put api_v1_maintenance_service_url(@maintenance_service.last.id + 100), headers: { 'Authorization' => "Bearer #{@token}" }, as: :json

    assert_response :not_found
  end

  test "should update the selected maintenance_service" do
    put api_v1_maintenance_service_url(@maintenance_service[0].id),
      headers: { 'Authorization' => "Bearer #{@token}" }, as: :json,
      params: {
        maintenance_service: {
          car_id: 1,
          description: "Cambio de balatas",
          status: "pending",
          date: "1990-12-31"
          }
      },
      as: :json

    assert_response :success

    maintenance_service_response = JSON.parse(response.body)

    db_maintenance_service = MaintenanceService.find(@maintenance_service[0].id)
    response_maintenance_service = maintenance_service_response["maintenance_service"]

    assert_equal db_maintenance_service.car_id, response_maintenance_service["car_id"]
    assert_equal db_maintenance_service.description, response_maintenance_service["description"]
    assert_equal db_maintenance_service.status, response_maintenance_service["status"]
    assert_equal db_maintenance_service.date, Date.parse(response_maintenance_service["date"])
  end


  # # destroy CarController test
  test "in delete, token should be valid" do
    token = "fake_token"
    delete api_v1_maintenance_service_url(@maintenance_service[0].id), headers: { 'Authorization' => "Bearer #{token}" }, as: :json

    assert_response :unauthorized

    maintenance_service_response = JSON.parse(response.body)

    assert_equal "Unauthorized", maintenance_service_response["error"]
  end

  test "the maintenance_service_id should exist to delete it" do
    delete api_v1_maintenance_service_url(@maintenance_service.last.id + 100), headers: { 'Authorization' => "Bearer #{@token}" }, as: :json

    assert_response :not_found
  end

  test "should be delete it" do
    assert_equal 70, MaintenanceService.all.count

    delete api_v1_maintenance_service_url(@maintenance_service.last.id), headers: { 'Authorization' => "Bearer #{@token}" }, as: :json

    assert_response :no_content

    assert_equal 69, MaintenanceService.all.count
  end
end
