
require 'rake/clean'
require 'rake/testtask'
require 'rake/gempackagetask'

PKG_VERSION = '0.1.0'

task :default => [ :gem ]
task :gem => [ :test ]

Rake::TestTask.new do |t|
  t.test_files = FileList['test/test_*.rb']
  t.verbose = true
end

gem_spec = Gem::Specification.new do |s|
  s.name = 'irc2html'
  s.version = PKG_VERSION
  s.author = 'Trejkaz'
  s.email = 'trejkaz at trypticon dot org'
  #s.homepage
  s.platform = Gem::Platform::RUBY
  s.summary = "Converts IRC formatting code to HTML."
  #s.description = <<EOF
  s.requirements << 'none'
  s.files = FileList["{doc,examples,lib,test}/**/*"].exclude("rdoc").to_a
  s.require_path = 'lib'
end

Rake::GemPackageTask.new(gem_spec) do |pkg|
  pkg.need_tar = true
end


CLEAN.include('pkg')


