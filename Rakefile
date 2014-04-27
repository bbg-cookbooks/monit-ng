#!/usr/bin/env rake

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:chefspec)

require 'rubocop/rake_task'
Rubocop::RakeTask.new

require 'foodcritic'
FoodCritic::Rake::LintTask.new

require 'kitchen/rake_tasks'
Kitchen::RakeTasks.new

task :default => %w( rubocop foodcritic chefspec )
task :all => %w( default kitchen:all )
