#!/usr/bin/env rake

# Install tasks to build and release the plugin
require 'bundler/setup'
Bundler::GemHelper.install_tasks

# Install test tasks
require 'rspec/core/rake_task'
desc "Run RSpec"
RSpec::Core::RakeTask.new

# Install tasks to package the plugin for Killbill
require 'killbill/rake_task'
Killbill::PluginHelper.install_tasks

task :vendor do
  FileUtils.rm_rf('vendor/jar-dependencies')
  exit(1) unless system './gradlew --no-daemon vendor'
end

# Run tests by default
task :default => :spec