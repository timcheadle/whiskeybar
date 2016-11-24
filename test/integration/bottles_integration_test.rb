require "test_helper"

class BottlesIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    @alice = users(:alice)
    @alice_bottle = bottles(:alice_bourbon)
    @bob_bottle = bottles(:bob_bourbon)
  end

  test "index only shows current user's bottles" do
    login_as(@alice)
    visit root_path

    assert page.has_content? @alice_bottle.name
    refute page.has_content? @bob_bottle.name
  end
end
