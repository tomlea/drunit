require 'drb'
require 'ruby2ruby'

module Drunit
  class RemoteApp
    def initialize(name, boot = nil, dir = nil)
      @name = name
      @boot = boot
      @dir = File.expand_path(dir || name.to_s)
      @boot ||= "test/drunit_test_helper.rb" if File.exist? "#{@dir}/test/drunit_test_helper.rb"
      @boot ||= "test/test_helper.rb" if File.exist? "#{@dir}/test/test_helper.rb"
      @remote_object = nil
    end

    def new_test_case(class_name = "Test::Unit::TestCase")
      app.new_test_case(class_name)
    end

  private
    def get_url(pipe)
      pipe.each_line do |line|
        return $1 if line =~ /^DRUNIT:URI (.*)$/
        raise "Could not establish connection to the remote drunit instance, From drunit_remote(#{@name})>> #{line}"
      end
    end

    def start_app!
      drb_server = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "bin", "drunit_remote"))
      pipe = Dir.chdir(@dir){IO.popen("#{drb_server} #{@boot}")}

      at_exit {Process.kill('SIGTERM', pipe.pid)}

      url = get_url(pipe)
      DRbObject.new(nil, url)
    end

    def app
      @remote_object ||= start_app!
    end
  end
end
