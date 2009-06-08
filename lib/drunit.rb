require "rubygems"

module Drunit

  module ClassMethods
    def RemoteApp(name, *args)
      const_set "RemoteAppFor_#{name}", RemoteApp.new(name, *args)
    end

    def drunit_test_case_class_name
      @drunit_test_case_class_name ||
        (superclass.respond_to?(:drunit_test_case_class_name) ? superclass.drunit_test_case_class_name : "Test::Unit::TestCase")
    end

    def set_drunit_test_case_class_name(name)
      @drunit_test_case_class_name = name
    end
  end

  def in_app(name, *args, &block)
    file, line, method = caller_file_and_method_for_block(&block)
    test_case = remote_test_case_for(name)
    test_case.define(block_to_source(method, &block), file, line)
    test_case.run(method, *args)
  rescue Exception => e
    rewrite_backtrace(e, method, name) or raise
  ensure
    test_case.assertion_count.times{ add_assertion } rescue nil
  end

private
  def rewrite_backtrace(e, method_name, app_name)
    backtrace = e.backtrace
    if first_remote_line = backtrace.grep(Regexp.new(method_name)).first
      index = backtrace.index(first_remote_line)
      backtrace = backtrace[0..index] + ["in drunit_remote(#{app_name})"] + caller(1)
      backtrace.map!{|line| line.gsub(/\(druby:\/\/[^\)]+\) /, "")}
      raise e, e.message, backtrace
    end
  end

  def block_to_source(method_name, &block)
    m = Module.new
    m.send(:define_method, method_name, &block)
    Ruby2Ruby.translate(m, method_name)
  end

  def remote_app_for(name)
    self.class.const_get("RemoteAppFor_#{name}")
  end

  def remote_test_case_for(name)
    @remote_test_cases ||= {}
    @remote_test_cases[name.to_sym] ||= remote_app_for(name).new_test_case(drunit_test_case_class_name)
  end

  def set_drunit_test_case_class_name(name)
    @drunit_test_case_class_name = name
  end

  def drunit_test_case_class_name
    @drunit_test_case_class_name || self.class.drunit_test_case_class_name
  end

  def caller_file_and_method_for_block(&block)
    eval(%%caller(0)[0] =~ /in `(.*)'/; [__FILE__, __LINE__, $1 || 'unknown_method']%, block.binding)
  end

  def self.included(other)
    other.send(:extend, ClassMethods)
  end
end

require File.join(File.dirname(__FILE__), *%w[drunit remote_app])
require File.join(File.dirname(__FILE__), *%w[drunit remote_error])

