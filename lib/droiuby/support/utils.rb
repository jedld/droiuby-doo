module Droiuby
  class Utils

    def self.start_web_console(&block)
      listener = Droiuby::Wrappers::Listeners::OnWebConsoleReadyListener.new(_execution_bundle,block)
      Java::com.droiuby.client.core.DroiubyLauncher.setupConsole(_execution_bundle, listener.to_native)
    end

  end
end