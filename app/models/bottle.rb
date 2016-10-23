class Bottle < ApplicationRecord
  validates :name, presence: true
  #validates :producer, presence: true
  validates :spirit, presence: true
  validates :location, presence: true, unless: :finished?
  validates :acquired_on, presence: true

  validates :volume, presence: true
  validates :volume, numericality: { greater_than: 0, only_integer: true }

  validates :proof, numericality: { greater_than: 0, allow_nil: true }

  validates :release_year, numericality: { greater_than: 0, only_integer: true, allow_nil: true }
end
