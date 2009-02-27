require File.join(File.dirname(__FILE__), *%w[.. test_helper])

class ExceptionHandlingTest < Test::Unit::TestCase
  include Drunit
  RemoteApp(:fake_app, FAKE_APP_PATH + "/fake_app.rb")
  def InApp(*args, &block)
    in_app(:fake_app, *args, &block)
  end

  def test_should_raise_a_generic_exception
    assert_raise(Drunit::RemoteError) { InApp{ raise MyModule::SomeOtherException} }
  end
end
