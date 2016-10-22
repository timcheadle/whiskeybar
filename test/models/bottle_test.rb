require 'test_helper'

class BottleTest < ActiveSupport::TestCase
  def setup
    @bottle = bottles(:bourbon)
  end

  test "has a valid fixture" do
    assert @bottle.valid?
  end

  should validate_presence_of(:name)
  should validate_presence_of(:producer)
  should validate_presence_of(:spirit)
  should validate_presence_of(:location)
  should validate_presence_of(:acquired_on)

  should validate_presence_of(:volume)
  should validate_numericality_of(:volume).is_greater_than(0).only_integer

  should validate_presence_of(:proof)
  should validate_numericality_of(:proof).is_greater_than(0)

  should validate_numericality_of(:release_year).is_greater_than(0).only_integer
end
