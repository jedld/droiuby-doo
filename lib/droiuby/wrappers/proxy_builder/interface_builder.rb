module Droiuby
  module Wrappers
    module ProxyBuilder
      class InvocationHandler
        
        def initialize(klass_name, backing_object)
          handler = Java::com.droiuby.client.core.wrappers.InvocationHandlerRubyWrapper.new(_execution_bundle, self)
          @backing_object = backing_object
          @native = Java::com.droiuby.client.core.InterfaceGenerator.wrapperForClassOrInterface(_current_activity, klass_name, handler)
        end

        def invoke(object, method, params)
            method_name = method.getName
            @backing_object.send(method_name, *params)
        end

        def to_native
          @native
        end
      end

    end
  end
end