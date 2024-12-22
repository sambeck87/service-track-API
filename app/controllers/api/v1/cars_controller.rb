class Api::V1::CarsController < ApplicationController

  def index
    cars = Car.all
    render json: cars, each_serializer: Api::V1::CarSerializer
  end

  def show
    car = Car.find_by(id: params[:id])
    return not_found unless car

    render json: car, serializer: Api::V1::CarSerializer
  end

  def create
    car = Car.create!(car_params)

    render json: car, serializer: Api::V1::CarSerializer
  end

  def update
    car = Car.find_by(id: params[:id])
    return not_found unless car

    car.with_lock do
      car.update!(car_params)
    end

    render json: car, serializer: Api::V1::CarSerializer
  end

  def destroy
    car = Car.find_by(id: params[:id])
    return not_found unless car

    car.destroy!

    head :no_content
  end

  private

  def car_params
    params.require(:car).permit(:plate_number, :model, :year)
  end
end
