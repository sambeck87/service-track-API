class MaintenanceService < ApplicationRecord
  belongs_to :car

  enum status: [:pending, :in_progress, :completed]

  validates :status, presence: true
  validates :description, presence: true
  validate :validate_date

  scope :by_status, ->(status){ where(status: status ) }

  scope :by_plate_number, ->(plate_number) {
    joins(:car).where(car: { plate_number: plate_number })
  }

  private

  def validate_date
    if date.blank? || !(date.is_a?(Date) || date.is_a?(Time)) || date > Date.today
      errors.add(:date, "must not exceed the current year")
      return
    end

    begin
      Date.parse(date.to_s)
    rescue ArgumentError
      errors.add(:date, "must be a valid date")
    end
  end
end
