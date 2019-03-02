# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "active_proxy/version"

Gem::Specification.new do |spec|
  spec.name          = "active_proxy"
  spec.version       = ActiveProxy::VERSION
  spec.authors       = ["sebi"]
  spec.email         = ["gore.sebyx@yahoo.com"]

  spec.summary       = "Ruby proxy fetcher and manager"
  spec.description   = "Easy to use ruby proxy fetcher, supports caching and retries"
  spec.homepage      = "https://github.com/sebyx07/active_proxy"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", ">= 1.6.8"
  spec.add_dependency "proxy_fetcher", ">= 0.9.0"
  spec.add_dependency "retries", ">= 0.0.5"
  spec.add_dependency "user-agent-randomizer", ">= 0.2.0"
  spec.add_dependency "zeitwerk", ">= 1.0.0"

  spec.add_development_dependency "activesupport", ">= 5.0.0"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "http", ">= 3.0.0"
  spec.add_development_dependency "httparty", "~> 0.16.4"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.65.0"
  spec.add_development_dependency "rubocop-rails_config", "~> 0.4.3"
  spec.add_development_dependency "typhoeus", "~> 1.3.1"
end
