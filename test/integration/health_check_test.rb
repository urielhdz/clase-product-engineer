require "test_helper"

class HealthCheckTest < ActionDispatch::IntegrationTest
  test "el endpoint /up responde 200 cuando la app arranca" do
    get rails_health_check_path

    assert_response :success
  end
end
