require 'rake'
require 'rake/testtask'

task :default => [:test_units]

desc "Run basic tests"
Rake::TestTask.new("tests") { |t|
  t.pattern = 'test/*/*.rb'
  t.verbose = false
  t.warning = false
}
