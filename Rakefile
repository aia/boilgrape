# encoding: utf-8

require 'rubygems'
require 'bundler'
require 'bundler/setup'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'
require 'rake/packagetask'
require 'find'

PWD = File.expand_path(File.dirname(__FILE__))

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

# require 'cucumber/rake/task'
# Cucumber::Rake::Task.new(:features)

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new

namespace :server do
  desc "Start the server"
  task :start do
    %x("cd #{PWD}; JRUBY_OPTS='' ruby bin/puma -C config/puma.rb")
  end
end

desc "Package for distribution"
task :deployment do
  #Bundler.with_clean_env do
    sh "JRUBY_OPTS='' bundle install --deployment"
    sh "JRUBY_OPTS='' bundle package --all"
  #end
  unless (File.exists?("vendor/jruby-complete-1.7.4.jar"))
    require 'net/http'
    # http://jruby.org.s3.amazonaws.com/downloads/1.7.4/jruby-complete-1.7.4.jar
    Net::HTTP.start("jruby.org.s3.amazonaws.com") do |http|
      resp = http.get("/downloads/1.7.4/jruby-complete-1.7.4.jar")
      open("vendor/jruby-complete-1.7.4.jar", "w") { |file| file.write(resp.body) }
    end
  end
end

Rake::PackageTask.new("boil-grape", "1.0") do |p|
  p.tar_command = "COPYFILE_DISABLE='true' tar"
  p.need_tar = true
  Find.find('app', 'bin', 'lib', 'rackup', 'spec', 'vendor', '.bundle') do |path|
    p.package_files << path
  end
  p.package_files.include(
    "Gemfile*",
    "Rakefile",
    "README.md",
    "LICENSE.txt",
    ".rspec",
    ".rvmrc",
    ".document",
    ".rbenv-version"
  )
end


