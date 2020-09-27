require 'csv'

class Bottle < ApplicationRecord
  include PgSearch

  acts_as_taggable

  attr_accessor :abv, :quantity

  belongs_to :user
  validates :user, presence: true

  validates :name, presence: true
  validates :spirit, presence: true
  validates :location, presence: true, unless: -> (bottle) { bottle.finished? }
  validates :acquired_on, presence: true

  validates :volume, presence: true
  validates :volume, numericality: { greater_than: 0, only_integer: true }

  validates :quantity, numericality: { greater_than: 0, only_integer: true }

  validates :proof, numericality: { greater_than: 0 }, allow_blank: true
  validates :abv, numericality: { greater_than: 0 }, allow_blank: true

  validates :release_year, numericality: { greater_than: 0, only_integer: true, allow_blank: true }

  scope :open, -> { where(open: true) }
  scope :unopened, -> { where(open: false) }
  scope :finished, -> { where.not(finished_on: nil) }
  scope :current, -> { where(finished_on: nil) }
  scope :stocked, -> { where(in_stock: true) }
  scope :unstocked, -> { where(in_stock: false) }

  pg_search_scope :search_for,
    against: %i(name details producer spirit release_year notes location),
    using: {
      tsearch: { prefix: true }
    }

  def finished?
    finished_on.present?
  end

  def quantity
    @quantity || 1
  end

  def abv=(new_abv)
    @abv = new_abv
    self[:proof] = @abv.to_i * 2 if proof.nil?
  end

  def location=(new_location)
    self[:location] = new_location.try(:titleize)
  end

  def spirit=(new_spirit)
    self[:spirit] = new_spirit.try(:titleize)
  end

  def self.to_csv
    attributes = %w(
      name
      details
      spirit
      release_year
      producer
      volume
      proof
      price
      location
      open
      in_stock
      source
      acquired_on
      finished_on
      tag_list
      notes
      created_at
      updated_at
    )

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |bottle|
        csv << attributes.map { |attr| bottle.send(attr) }
      end
    end
  end
end
