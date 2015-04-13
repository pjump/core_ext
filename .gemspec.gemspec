# coding: utf-8

require_relative 'gemspec_boilerplate'

spec = Gem::Specification.new do |s|

  GemspecBoilerplate.boilerplate(s)

  #s.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."

  #####Must change
  s.summary       = %q{Mixins to extend the core with}
  s.description   = s.summary
  s.licenses      = %w[mit]


  #####Unlikely to change
  s.email         = [ `git config user.email` ]
  s.homepage      = "https://github.com/#{`git config github.username`.chomp}/#{s.name}"
  ###################################

  s.add_dependency 'i18n',       '~> 0.7'
  s.add_dependency 'json',       '~> 1.7', '>= 1.7.7'
  s.add_dependency 'tzinfo',     '~> 1.1'
  s.add_dependency 'attach_function'

  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "pry"
  s.add_development_dependency "rspec"

end
