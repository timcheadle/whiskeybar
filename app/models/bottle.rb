class Bottle < ApplicationRecord
  validates :name, presence: true
  validates :producer, presence: true
  validates :spirit, presence: true
  validates :location, presence: true
  validates :acquired_on, presence: true

  validates :volume, presence: true
  validates :volume, numericality: { greater_than: 0, only_integer: true }

  validates :proof, presence: true
  validates :proof, numericality: { greater_than: 0 }

  validates :release_year, numericality: { greater_than: 0, only_integer: true }
end
