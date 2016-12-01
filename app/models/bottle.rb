class Bottle < ApplicationRecord
  attr_accessor :quantity

  belongs_to :user
  validates :user, presence: true

  validates :name, presence: true
  validates :spirit, presence: true
  validates :location, presence: true, unless: -> (bottle) { bottle.finished? }
  validates :acquired_on, presence: true

  validates :volume, presence: true
  validates :volume, numericality: { greater_than: 0, only_integer: true }

  validates :quantity, numericality: { greater_than: 0, only_integer: true }

  validates :proof, numericality: { greater_than: 0, allow_nil: true }

  validates :release_year, numericality: { greater_than: 0, only_integer: true, allow_nil: true }

  scope :open, -> { where(open: true) }
  scope :finished, -> { where.not(finished_on: nil) }
  scope :current, -> { where(finished_on: nil) }

  def finished?
    finished_on.present?
  end

  def quantity
    @quantity || 1
  end

  def location=(new_location)
    self[:location] = new_location.try(:capitalize)
  end

  def spirit=(new_spirit)
    self[:spirit] = new_spirit.try(:capitalize)
  end
end
