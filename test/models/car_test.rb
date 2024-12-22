require "test_helper"

class CarTest < ActiveSupport::TestCase
  test "should be valid" do
    car = Car.new(plate_number: "YJS-666-B", model: "Accord", year: 2024)
    assert car.valid?
  end

  test "should be uniq" do
    car = Car.create!(plate_number: "YJS-666-B", model: "Accord", year: 2024)

    car = Car.new(plate_number: "YJS-666-B", model: "Accord", year: 2024)
    assert_not car.valid?
  end

  test "year should be >= than 1900 and <= current year" do
    car = Car.new(plate_number: "YJS-666-B", model: "Accord", year: Date.today.year + 1)
    assert_not car.valid?

    car = Car.new(plate_number: "YJS-666-B", model: "Accord", year: 1880)
    assert_not car.valid?
  end

  test "year should be present" do
    car = Car.new(plate_number: "YJS-666-B", model: "Accord", year: "")
    assert_not car.valid?
  end

  test "year should be a number" do
    car = Car.new(plate_number: "YJS-666-B", model: "Accord", year: "numero")
    assert_not car.valid?
  end

  test "plate_number should be present" do
    car = Car.new(plate_number: "", model: "Accord", year: 2020)
    assert_not car.valid?
  end
end
