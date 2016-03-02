# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "slink/version"

Gem::Specification.new do |s|
  s.name        = "slink"
  s.version     = Slink::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ryan Wood", "the_angry_angel"]
  s.email       = ["ryan.wood@gmail.com", "karl+github@theangryangel.co.uk"]
  s.homepage    = "http://github.com/theangryangel/slink"
  s.summary     = %q{A simple, clean DSL for describing, writing, and parsing character separated files with sections. Heavily borrowed from slither.}
  s.description = %q{A simple, clean DSL for describing, writing, and parsing character separated files with sections. Heavily borrowed from slither.}

  s.files         = Dir.glob("{lib}/**/*") + %w(README.md)
  s.require_paths = ["lib"]
end
