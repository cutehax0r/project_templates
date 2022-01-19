# frozen_string_literal: true

require_relative "lib/project_templates/version"

Gem::Specification.new do |s|
  s.name = "project_templates"
  s.version = ProjectTemplates::VERSION
  s.authors = ["Cute HaX0r"]
  s.email = "cutehaX0r@github.com"

  s.summary = "Create boilerplate project structures or add files to existing projects"
  s.license = "MIT"
  s.required_ruby_version = ">= 3.1.0"

  s.require_paths = ["lib"]
  s.files = Dir["lib/**/*"]
  s.executables = Dir["exe/*"]
  s.bindir = "exe"
  s.metadata["yard.run"] = "yard"

  s.extra_rdoc_files = ["README.md"]
  s.rdoc_options += [
    "--main", "README.md",
    "--line-numbers",
    "--inline-source",
    "--quiet"
  ]

  s.add_development_dependency "github-markup"
  s.add_development_dependency "minitest"
  s.add_development_dependency "pry"
  s.add_development_dependency "redcarpet"
  s.add_development_dependency "rubocop"
  s.add_development_dependency "sorbet"
  s.add_development_dependency "yard"

  s.add_dependency "sorbet-runtime"
  s.add_dependency "tapioca"
end
