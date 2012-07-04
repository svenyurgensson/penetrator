#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/testtask'

desc 'Default: Run all specs.'
task :default => :test

Rake::TestTask.new do |t|
  t.libs = ["lib"]
  t.warning = true
  t.test_files = FileList['specs/**/*_spec.rb']
end
