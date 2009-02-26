require 'drb'
require 'ruby2ruby'

module Drunit
  class RemoteApp
    def initialize(name, boot = nil)
      @name = name
      @boot = boot || "name/script/runner"
      @remote_object = nil
    end

    def run(method_name, file, line, *args, &block)
      raise_or_return(app.eval(block_to_source(method_name, &block), file, line, method_name, *args), method_name)
    end

    def last_assertion_count
      app.last_assertion_count
    end

  private
    def raise_or_return(e, method_name)
      return e unless e.is_a? Exception
      if first_remote_line = e.backtrace.grep(Regexp.new(method_name)).last
        index = e.backtrace.index(first_remote_line)
        raise e, e.message, e.backtrace[0..index] + ["RemoteApp<#{@name}>"] + caller(0)
      end
      raise e
    end

    def start_app!
      drb_server = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "bin", "drunit_remote"))
      pipe = IO.popen("#{drb_server} #{@boot}")
      pid = pipe.pid
      url = pipe.gets.chomp
      remote_object = DRbObject.new(nil, url)
      ObjectSpace.define_finalizer(remote_object, proc{|id| Process.kill("KILL", pid) && Process.wait})
      return remote_object
    end

    def app
      @remote_object ||= start_app!
    end

    def block_to_source(method_name, &block)
      m = Module.new
      m.send(:define_method, method_name, &block)
      Ruby2Ruby.translate(m, method_name)
    end
  end
end
