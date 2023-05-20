require "test_helper"

class SurveyControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get survey_index_url
    assert_response :success
  end

  test "should get new" do
    get survey_new_url
    assert_response :success
  end

  test "should get show" do
    get survey_show_url
    assert_response :success
  end
end
