require 'drb'
require 'ruby2ruby'

module Drunit
  class RemoteApp
    def initialize(name, boot = nil)
      @name = name
      @boot = boot
      @boot ||= "#{name}/test/drunit_test_helper.rb" if File.exist? "#{name}/test/drunit_test_helper.rb"
      @boot ||= "#{name}/test/test_helper.rb" if File.exist? "#{name}/test/test_helper.rb"
      @remote_object = nil
    end

    def new_test_case(class_name = "Test::Unit::TestCase")
      app.new_test_case(class_name)
    end

  private
    def get_url(pipe)
      pipe.each_line do |line|
        return $1 if line =~ /^DRUNIT:URI (.*)$/
        STDERR.puts "From drunit_remote(#{@name})>> #{line}"
      end
    end

    def start_app!
      drb_server = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "bin", "drunit_remote"))
      pipe = IO.popen("#{drb_server} #{@boot}")
      pid = pipe.pid
      url = get_url(pipe) or raise "Could not establish connection to the remote drunit instance."
      remote_object = DRbObject.new(nil, url)
      ObjectSpace.define_finalizer(remote_object, proc{|id| Process.kill("KILL", pid) && Process.wait})
      return remote_object
    end

    def app
      @remote_object ||= start_app!
    end
  end
end
