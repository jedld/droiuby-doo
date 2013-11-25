Gem::Specification.new do |s|
  s.name        = 'droiuby'
  s.version     = '0.0.4'
  s.date        = '2013-11-16'
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
  s.post_install_message = "Droiuby Gem Installed!\nPost Install work:\n" + "1.Go install the droiuby development app here:\n" +
     "2. Download the android sdk (http://developer.android.com/sdk/index.html)\n" +
     "3. Setup your PATH to include <sdk directory>/sdk/platform-tools (make sure adb works)\n" +
     "4. Attach your android phone to your PC via USB and start rocking!!\n"
end
