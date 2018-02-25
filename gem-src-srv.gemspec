lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gem/src/srv/version"

Gem::Specification.new do |spec|
  spec.name          = "gem-src-srv"
  spec.version       = Gem::Src::Srv::VERSION
  spec.authors       = ["Masataka Pocke Kuwabara"]
  spec.email         = ["kuwabara@pocke.me"]

  spec.summary       = %q{Run `git clone` after `gem install` concurrently.}
  spec.description   = %q{Run `git clone` after `gem install` concurrently.}
  spec.homepage      = "https://github.com/pocke/gem-src-srv"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.3.0'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "retryable", "~> 3.0"
end
