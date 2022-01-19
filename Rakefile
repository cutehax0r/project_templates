# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require "rubocop/rake_task"
require "yard"

RuboCop::RakeTask.new(:lint) do |t|
  t.options = ["--display-cop-names"]
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

task :type_check do
  sh "srb tc"
end

YARD::Rake::YardocTask.new(:doc) do |t|
  t.files = ["lib/**/*.rb", "-", "LICENSE.txt"]
  t.options = ["--main", "README.md"]
end

task default: %i[type_check test lint]
