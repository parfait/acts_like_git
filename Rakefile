require 'rake/rdoctask'
require 'spec/rake/spectask'
require 'rake/gempackagetask'

desc 'Default: run specs'
task :default => :spec

desc "Run the specs under spec"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc "Generate RCov reports"
Spec::Rake::SpecTask.new(:rcov) do |t|
  t.libs << 'lib'
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec', '--exclude', 'gems', '--exclude', 'riddle']
end