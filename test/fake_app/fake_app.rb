class SomeFoo
  def multiply(a,b)
    a * b
  end
end

class SomeException < Exception
end

class SomeOtherTestCase
  def assert_in_new_test_case
    add_assertion
  end
end

module MyModule
  class SomeOtherException < Exception
  end
end
