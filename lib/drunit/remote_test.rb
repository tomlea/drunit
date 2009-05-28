require 'drb'
require 'test/unit'
require File.join(File.dirname(__FILE__), *%w[remote_error])

module Drunit
  class RemoteTest
    attr_reader :last_assertion_count

    class TestCase
      include Test::Unit::Assertions
      attr_reader :assertion_count

      def initialize(code, source_file, source_line, method_name)
        @assertion_count = 0
        @method_name = method_name
        instance_eval(code, source_file, source_line)
      end

      def add_assertion
        @assertion_count += 1
      end

      def run(*args)
        send(@method_name, *args)
      end
    end

    def eval(code, source_file, source_line, method_name, *args)
      test_case = TestCase.new(code, source_file, source_line, method_name)
      return rewrite_exceptions{ test_case.run(*args) }
    rescue Exception => e
      return e
    ensure
      @last_assertion_count = defined?(test_case.assertion_count) ? test_case.assertion_count : 0
    end
  private
    # We need to strib down and generalise the exceptions to prevent the integration project from having to know anything about anything.
    def rewrite_exceptions
      return yield
    rescue Test::Unit::AssertionFailedError
      raise
    rescue ArgumentError => e
      raise e unless e.message =~ /Anonymous modules /
      raise NameError, "Const Missing", e.backtrace[3..-1]
    rescue Exception => e
      raise Drunit::RemoteError.new(e.class.name), e.message, e.backtrace
    end
  end
end
