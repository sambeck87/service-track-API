require "test_helper"

class MaintenanceServiceTest < ActiveSupport::TestCase
  setup do
    @car = Car.create!(
      plate_number: "ABC123",
      model: "Sedan",
      year: 2020
    )

    @maintenance_service = MaintenanceService.create!(
      car_id: @car.id,
      description: "Cambio de balatas",
      status: "pending",
      date: "2024-12-12"
    )
  end
  test "should be valid" do
    maintenance_service = MaintenanceService.new(
      car_id: @car.id,
      description: "Mantenimiento preventivo (cambio de aceite y filtros)",
      status: "pending",
      date: "2024-12-12"
    )
    assert maintenance_service.valid?
  end

  test "car_id should be present and valid" do
    maintenance_service = MaintenanceService.new(
      car_id: @car.id + 1,
      description: "Mantenimiento preventivo (cambio de aceite y filtros)",
      status: "pending",
      date: "2024-12-12"
    )
    assert_not maintenance_service.valid?

    maintenance_service = MaintenanceService.new(
      car_id: "",
      description: "Mantenimiento preventivo (cambio de aceite y filtros)",
      status: "pending",
      date: "2024-12-12"
    )
    assert_not maintenance_service.valid?
  end

  test "description should be present" do
    maintenance_service = MaintenanceService.new(
      car_id: @car.id,
      description: "",
      status: "pending",
      date: "2024-12-12"
    )
    assert_not maintenance_service.valid?
  end

  test "status should be present" do
    maintenance_service = MaintenanceService.new(
      car_id: @car.id,
      description: "Mantenimiento preventivo (cambio de aceite y filtros)",
      status: "",
      date: "2024-12-12"
    )
    assert_not maintenance_service.valid?
  end

  test "date should be valid, date is invalid if is a future date" do
    maintenance_service = MaintenanceService.new(
      car_id: @car.id,
      description: "Mantenimiento preventivo (cambio de aceite y filtros)",
      status: "pending",
      date: Date.today + 1
    )
    assert_not maintenance_service.valid?

    maintenance_service = MaintenanceService.new(
      car_id: @car.id,
      description: "Mantenimiento preventivo (cambio de aceite y filtros)",
      status: "pending",
      date: "2025/34/12"
    )
    assert_not maintenance_service.valid?
  end

  test "status only admit 'pending', 'in_progress' and 'completed' values" do
    assert_equal "pending", @maintenance_service.status

    @maintenance_service.status = "in_progress"
    assert @maintenance_service.valid?
    assert_equal "in_progress", @maintenance_service.status

    @maintenance_service.status = "completed"
    assert @maintenance_service.valid?
    assert_equal "completed", @maintenance_service.status

    assert_raises(ArgumentError) do
      @maintenance_service.status = "done"
      assert_not @maintenance_service.valid?
      assert_includes @maintenance_service.errors[:status], "is not included in the list"
    end
  end

  test "MaintenanceService should be deleted if car is deleted" do
    assert_equal 1, MaintenanceService.all.count

    @car.destroy

    assert_equal 0, MaintenanceService.all.count
  end


end
