Gem::Specification.new do |s|
  s.name        = 'droiuby'
  s.version     = '0.3.4'
  s.date        = '2014-03-27'
  s.summary     = "Droiuby GEM"
  s.description = "Android app development and rapid prototyping using Ruby"
  s.authors     = ["Joseph Emmanuel Dayo"]
  s.email       = 'joseph.dayo@gmail.com'
  s.executables << 'drby'
  s.files       = ["lib/droiuby.rb"] +  Dir.glob("lib/droiuby/**/*")
  s.homepage    =
    'https://github.com/jedld/droiuby-doo'
  s.license       = 'Apache License, Version 2.0'
  s.add_runtime_dependency "rake", [">= 0"]
  s.add_runtime_dependency "thor", [">= 0"]
  s.add_runtime_dependency "rubyzip", [">= 1.0.0"]
  s.add_runtime_dependency "multipart-post", [">= 0"]
  s.add_runtime_dependency "properties-ruby", [">= 0"]
  s.add_runtime_dependency "nokogiri", [">= 0"]
  s.post_install_message = "Droiuby Gem Installed!\n\nPost Install work:\n\n" + "1.Go install the droiuby development app on your phone here: https://play.google.com/store/apps/details?id=com.droiuby.application\n" +
     "2. Download the android sdk (http://developer.android.com/sdk/index.html)\n" +
     "3. Setup your PATH to include <sdk directory>/sdk/platform-tools (make sure adb works)\n" +
     "4. Attach your android phone to your PC via USB\n" +
     "5. visit https://github.com/jedld/droiuby-doo for the quick start tutorial\n" +
     "\nDetails can be found in the README"

end
