# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hovering/version"

Gem::Specification.new do |spec|
  spec.name          = "hovering"
  spec.version       = Hovering::VERSION
  spec.authors       = ["Nick Gorbikoff"]
  spec.email         = ["ngorbikoff@ajrinlt.com"]

  spec.summary       = %q{Gem to access Hover.com API}
  spec.description   = %q{Hover.com is a domain registrar based in Canada, using Tucows platform. It doesn't have an official API. This gem is using "unofficial" API access points that the dashboard on Hover.com is using .}
  spec.homepage      = "https://github.com/konung/hovering"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "multi_json", "~> 1.12"
  spec.add_dependency "roar", "~> 1.1"
  spec.add_dependency "faraday", "~> 0.13"
  spec.add_dependency "virtus", "~> 1.0"
  spec.add_dependency "trailblazer", "~> 2.0"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry", "~> 0.11"
  spec.add_development_dependency "pry-byebug", "~> 3.5"
  spec.add_development_dependency "pry-doc", "~> 0.11"
  spec.add_development_dependency "awesome_print", "~> 1"
end
