#!/usr/bin/env rake

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:chefspec)

desc 'run ruby style guide linting'
task :rubocop do
  sh 'rubocop'
end

desc 'foodcritic cookbook style linter'
task :foodcritic do
  sh 'foodcritic --epic-fail any .'
end

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  puts 'test-kitchen gem not found. skipping.'
end

task :default => ['rubocop', 'foodcritic', 'chefspec']
