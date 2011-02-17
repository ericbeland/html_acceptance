# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{html_acceptance}
  s.version = "0.1.15"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Eric Beland"]
  s.date = %q{2011-02-17}
  s.description = %q{HTML Acceptance lets you accept warnings/errors.  Less noisey validation will hopefully let you build html validation into your test suite, but break the rules if you must.}
  s.email = %q{ebeland@testomatix.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "html_acceptance.gemspec",
    "lib/.rake",
    "lib/html_acceptance.rb",
    "lib/html_acceptance/html_acceptance_result.rb",
    "lib/tasks/html_acceptance.rake",
    "samples/have_valid_html.rb",
    "spec/html_acceptance_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/ericbeland/html_acceptance}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.requirements = ["HTML Tidy on the command PATH or at /usr/bin/tidy"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Wrapper for HTMLTidy that lets you accept warnings/errors}
  s.test_files = [
    "spec/html_acceptance_spec.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.3.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.3.0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.3.0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end

