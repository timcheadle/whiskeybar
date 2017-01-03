ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

require "minitest/reporters"
Minitest::Reporters.use!(
  Minitest::Reporters::ProgressReporter.new,
  ENV,
  Minitest.backtrace_filter)

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Warden::Test::Helpers

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def sign_in(user)
    login_as(user, scope: :user)
  end

  def sign_out
    logout(:user)
  end
end
