class Car < ApplicationRecord
  has_many :maintenance_services, dependent: :destroy

  validates :plate_number, presence: true, uniqueness: true
  validates :year, presence: true, inclusion: {
    in: 1900..Date.current.year,
    message: "must be between 1900 and current year"
  }
end
