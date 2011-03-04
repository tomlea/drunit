require File.join(File.dirname(__FILE__), *%w[.. test_helper])

class SomeOtherTestCaseTest < Test::Unit::TestCase
  include Drunit
  RemoteApp(:fake_app, "fake_app.rb", FAKE_APP_PATH)
  def InApp(*args, &block)
    in_app(:fake_app, *args, &block)
  end

  set_drunit_test_case_class_name "SomeOtherTestCase"

  def test_foo
    InApp{ assert_in_new_test_case }
  end

end

