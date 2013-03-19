## DO NOT RUN: haven't figured out how to make this work
require 'test/unit'

models = File.join(".", "test", "model")
puts models

runner = Test::Unit::AutoRunner.new(true)
puts runner

runner.to_run << models
runner.run

