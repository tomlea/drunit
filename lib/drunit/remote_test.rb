require 'drb'
require 'test/unit'
require File.join(File.dirname(__FILE__), *%w[remote_error])

module Drunit
  class RemoteTest
    def new_test_case(name)
      tc = Class.new(eval(name, Object.class_eval{ binding }))
      tc.send(:include, TestCaseModule)
      tc.allocate
    end

    module TestCaseModule
      def self.included(other)
        other.send(:class_eval) do
          include DRb::DRbUndumped
          attr_reader :assertion_count
        end
      end

      def initialize
        @assertion_count = 0
      end

      def add_assertion
        @assertion_count += 1
      end

      def define(code, source_file, source_line)
        instance_eval(code, source_file, source_line)
      end

      def run(method_name, *args)
        @assertion_count = 0
        rewrite_exceptions{ __send__(method_name, *args) }
      end

    private
      # We need to strip down and generalise the exceptions to prevent the integration project from having to know anything about anything.
      def rewrite_exceptions
        begin
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
  end
end
