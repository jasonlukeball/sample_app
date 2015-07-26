require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "layout links" do
    get root_path
    # Test that the template rendered is 'static_pages/home'
    assert_template 'static_pages/home'
    # Test that the following links appear somethere on the page
    assert_select "a[href=?]", root_path, count: 2    # Appears twice on the page
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end

end
