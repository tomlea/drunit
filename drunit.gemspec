Gem::Specification.new do |s|
  s.name        = %q{drunit}
  s.version     = "0.4.3"
  s.summary     = %q{A library for running tests across multiple applications from a single test case.}
  s.description = %q{A library for running tests across multiple applications from a single test case.}

  s.files        = Dir.glob('{app,lib,rails}/**/*')
  s.executables  = "drunit_remote"
  s.require_path = 'lib'
  s.test_files   = Dir[*['test/**/*_test.rb']]

  s.add_dependency 'ruby2ruby', '~>1.1.0'

  s.has_rdoc         = true
  s.extra_rdoc_files = ["README.markdown"]
  s.rdoc_options = ['--line-numbers', '--inline-source', "--main", "README.markdown"]

  s.authors = ["Tom Lea"]
  s.email   = %q{commits@tomlea.co.uk}

  s.platform = Gem::Platform::RUBY
end
