module Drunit
  class RemoteError < RuntimeError
    def class
      if Object.const_defined?(@real_exception)
        Object.const_get(@real_exception)
      else
        e = Class.new(Exception)
        e.instance_eval("def name; #{@real_exception.inspect}; end" )
        e
      end
    end
  end

  module ClassMethods
    def RemoteApp(name, *args)
      const_set "RemoteAppFor_#{name}", RemoteApp.new(name, *args)
    end
  end

  def in_app(name, *args, &block)
    file, line, method = caller(2).first.split(":")
    remote_app_for(name).run(method.gsub(/^in /, "").gsub(/[^a-zA-Z0-9_?!]/, ""), file, line.to_i, *args, &block)
  ensure
    remote_app_for(name).last_assertion_count.times{ add_assertion } rescue nil
  end

  def remote_app_for(name)
    self.class.const_get("RemoteAppFor_#{name}")
  end

  def self.included(other)
    other.send(:extend, ClassMethods)
  end
end

require File.join(File.dirname(__FILE__), *%w[drunit remote_app])

