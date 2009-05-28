# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{drunit}
  s.version = "0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tom Lea"]
  s.date = %q{2009-05-28}
  s.default_executable = %q{drunit_remote}
  s.description = %q{A library for running tests across multiple applications from a single test case.}
  s.email = %q{commits@tomlea.co.uk}
  s.executables = ["drunit_remote"]
  s.extra_rdoc_files = ["README.markdown"]
  s.files = ["README.markdown", "Rakefile", "lib/drunit/remote_app.rb", "lib/drunit/remote_error.rb", "lib/drunit/remote_test.rb", "lib/drunit.rb", "test/fake_app/fake_app.rb", "test/test_helper.rb", "test/unit/exception_handling_test.rb", "test/unit/main_test.rb", "bin/drunit_remote"]
  s.has_rdoc = true
  s.rdoc_options = ["--line-numbers", "--inline-source", "--main", "README.markdown"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A library for running tests across multiple applications from a single test case.}
  s.test_files = ["test/unit/exception_handling_test.rb", "test/unit/main_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
