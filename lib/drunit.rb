require "rubygems"

module Drunit

  module ClassMethods
    def RemoteApp(name, *args)
      const_set "RemoteAppFor_#{name}", RemoteApp.new(name, *args)
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
    if first_remote_line = e.backtrace.grep(Regexp.new(method_name)).last
      index = e.backtrace.index(first_remote_line)
      raise e, e.message, e.backtrace[0..index] + ["in drunit_remote(#{app_name})"] + caller(0)
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
    @remote_test_cases[name.to_sym] ||= remote_app_for(name).new_test_case
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

