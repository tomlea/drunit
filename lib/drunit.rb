require "rubygems"
module Drunit
  class RemoteError < RuntimeError
    def self.name
      @@name
    end

    def class
      if type = look_up_exception
        return type
      else
        @@name = @real_exception.to_s
        super
      end
    end

    def look_up_exception
      @real_exception.split("::").inject(Object){|node, part|
        node && node.const_defined?(part) && node.const_get(part)
      }
    end
  end

  module ClassMethods
    def RemoteApp(name, *args)
      const_set "RemoteAppFor_#{name}", RemoteApp.new(name, *args)
    end
  end

  def in_app(name, *args, &block)
    file, line, method = eval("caller(0).first", block.binding).split(":")
    method ||= "unknown_method"
    method.gsub!(/^in /, "").gsub!(/[^a-zA-Z0-9_?!]/, "")
    remote_app_for(name).run(method, file, line.to_i, *args, &block)
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

