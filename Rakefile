require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'date'

task :default => :test

desc 'run tests.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
