module Droiuby
  module Wrappers
    module Listeners
      class OnWebConsoleReadyListener
        
        def initialize(execution_bundle, auto_wrap_block)
          @auto_wrap_block = auto_wrap_block
          @native = Java::com.droiuby.wrappers::OnWebConsoleReadyRubyWrapper.new(execution_bundle, self)
        end
        
        def onReady(httpd)
          on_ui_thread {
            @auto_wrap_block.call(httpd)
          }
        end
        
        def to_native
          @native
        end
      end
    end
  end
end