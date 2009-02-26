$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])
require "test/unit"
require "drunit"

FAKE_APP_PATH = File.join(File.dirname(__FILE__), *%w[fake_app])
