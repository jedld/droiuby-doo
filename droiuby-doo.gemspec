Gem::Specification.new do |s|
  s.name        = 'droiuby-doo'
  s.version     = '0.0.1'
  s.date        = '2013-10-07'
  s.summary     = "Droiuby GEM"
  s.description = "Android development using ruby"
  s.authors     = ["Joseph Emmanuel Dayo"]
  s.email       = 'joseph.dayo@gmail.com'
  s.executables << 'droiuby'
  s.files       = ["lib/droiuby.rb","lib/droiuby/project.thor"]
  s.homepage    =
    'http://rubygems.org/gems/droiuby-doo'
  s.license       = 'MIT'
  s.add_runtime_dependency "rake", [">= 0"]
  s.add_runtime_dependency "rspec" , [">= 0"]
  s.add_runtime_dependency "thor", [">= 0"]
  s.add_runtime_dependency "rubyzip", [">= 0"]
  s.add_runtime_dependency "multipart-post", [">= 0"]
  s.add_runtime_dependency "properties-ruby", [">= 0"]
  s.add_runtime_dependency "activesupport", [">= 0"]
end
