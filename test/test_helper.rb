ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"
require "database_cleaner/active_record"


class ActiveSupport::TestCase
  fixtures :all

  setup do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end

  def login_as(user)
    post login_path, params: { session: { email: user.email, password: 'password' } }
  end

  def json_response
    JSON.parse(@response.body)
  end
end
