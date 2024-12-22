class Api::V1::CarSerializer < ActiveModel::Serializer
  attributes :id, :plate_number, :model, :year
end
