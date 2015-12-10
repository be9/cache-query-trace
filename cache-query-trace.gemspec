# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = "cache-query-trace"
  spec.version       = CacheQueryTrace::VERSION
  spec.authors       = ["Oleg Dashevskii"]
  spec.email         = ["olegdashevskii@gmail.com"]

  spec.summary       = %q{Print stack trace of all cache queries to the Rails log. Helpful to find where cache queries are being executed in your application"}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/be9/cache-query-trace"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 3.0"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
