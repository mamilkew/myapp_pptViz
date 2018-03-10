require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "#info"
  end

  test "should get info" do
    get pages_info_url
    assert_response :success
    assert_select "h1", "Pages#{@base_title}"
  end

  test "should get home" do
    get pages_home_url
    assert_response :success
  end

  test "should get help" do
    get pages_help_url
    assert_response :success
  end

end
