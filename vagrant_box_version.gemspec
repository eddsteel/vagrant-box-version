# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant_box_version/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant_box_version"
  spec.version       = VagrantBoxVersion::VERSION
  spec.authors       = ["Edd Steel"]
  spec.email         = ["edward.steel@hootsuite.com"]
  spec.description   = "Plugin to provide version information for boxes"
  spec.summary       = "Plugin to provide version information for boxes"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `find lib -type f`.split($/) +
    ["Gemfile", "LICENSE.txt", "README.md", "Rakefile", "vagrant_box_version.gemspec"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
