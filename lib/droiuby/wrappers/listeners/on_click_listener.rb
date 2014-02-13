module Droiuby
  module Wrappers
    module Listeners
      class OnClickListener
        
        def initialize(execution_bundle, auto_wrap_block)
          @auto_wrap_block = auto_wrap_block
          @native = ProxyBuilder::InvocationHandler.new("android.view.View.OnClickListener", self).to_native
        end
        
        def onClick(view)
          @auto_wrap_block.call(view)
        end
        
        def to_native
          @native
        end
      end
    end
  end
end