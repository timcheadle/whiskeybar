require 'test_helper'

class BottleTest < ActiveSupport::TestCase
  def setup
    @bottle = bottles(:alice_bourbon)
  end

  test "has a valid fixture" do
    assert @bottle.valid?
  end

  should belong_to(:user)
  should validate_presence_of(:user)

  should validate_presence_of(:name)
  should validate_presence_of(:spirit)
  should validate_presence_of(:acquired_on)
  should validate_presence_of(:volume)

  should validate_numericality_of(:volume).is_greater_than(0).only_integer
  should validate_numericality_of(:proof).is_greater_than(0).allow_nil
  should validate_numericality_of(:release_year).is_greater_than(0).only_integer.allow_nil
  should validate_numericality_of(:quantity).is_greater_than(0).only_integer

  test "#finished?" do
    @bottle.finished_on = nil
    refute @bottle.finished?

    @bottle.finished_on = Date.today
    assert @bottle.finished?
  end

  test "location should be present if not finished" do
    @bottle.finished_on = nil
    @bottle.location = nil
    refute @bottle.valid?

    @bottle.location = "Bar"
    assert @bottle.valid?
  end

  test "location can be nil if finished" do
    @bottle.location = nil
    @bottle.finished_on = Date.today
    assert @bottle.valid?
  end
end
