Gem::Specification.new do |s|
  s.name        = 'droiuby'
  s.version     = '0.0.3'
  s.date        = '2013-11-15'
  s.summary     = "Droiuby GEM"
  s.description = "Android development using ruby"
  s.authors     = ["Joseph Emmanuel Dayo"]
  s.email       = 'joseph.dayo@gmail.com'
  s.executables << 'drby'
  s.files       = ["lib/droiuby.rb","lib/droiuby/project.rb"] + Dir.glob("lib/droiuby/templates/**/*")
  s.homepage    =
    'http://rubygems.org/gems/droiuby'
  s.license       = 'MIT'
  s.add_runtime_dependency "rake", [">= 0"]
  s.add_runtime_dependency "thor", [">= 0"]
  s.add_runtime_dependency "rubyzip", [">= 1.0.0"]
  s.add_runtime_dependency "multipart-post", [">= 0"]
  s.add_runtime_dependency "properties-ruby", [">= 0"]
  s.add_runtime_dependency "activesupport", [">= 0"]
end
