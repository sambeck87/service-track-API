class Api::V1::MaintenanceServiceSerializer < ActiveModel::Serializer
  attributes :id, :car_id, :description, :status, :date

  has_one :car, serializer: Api::V1::CarSerializer, if: :include_car?

  def include_car?
    instance_options[:include_fields]&.include?('car')
  end
end
