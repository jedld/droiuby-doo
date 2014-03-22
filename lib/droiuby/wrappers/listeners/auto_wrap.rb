module Droiuby
  module Wrappers
    module Listeners

      class AutoWrapBase
        def to_native(klass, package = 'android.view.View')
          Droiuby::Wrappers::ProxyBuilder::InvocationHandler.new("#{package}$#{klass}", self).to_native
        end
      end

      class AutoWrap < AutoWrapBase

        def initialize(execution_bundle, auto_wrap_block)
          @execution_bundle = execution_bundle
          @auto_wrap_block = auto_wrap_block
        end

        def method_missing(meth, *args, &block)
          if meth.to_s =~ /^on(.+)$/
            wrapped_args = args.collect { |a|
              wrap_native_view(a)
            }
            @auto_wrap_block.call(*wrapped_args)
          else
            super # You *must* call super if you don't handle the
                  # method, otherwise you'll mess up Ruby's method
                  # lookup.
          end
        end


      end

      class AutoWrapMultiple < AutoWrapBase

        def initialize(execution_bundle, impl_blocks = {})
          @execution_bundle = execution_bundle
          @auto_wrap_blocks = impl_blocks
        end

        def impl(method, &block)
          @auto_wrap_block["on#{meth.to_s.camelize}"] = block
        end

        def method_missing(meth, *args, &block)
          if meth.to_s =~ /^on(.+)$/
            wrapped_args = args.collect { |a|
              wrap_native_view(a)
            }
            @auto_wrap_block[meth.to_s].call(*wrapped_args)
          else
            super # You *must* call super if you don't handle the
                  # method, otherwise you'll mess up Ruby's method
                  # lookup.
          end
        end
      end

      def on(event,&block)
        listener_ref = event.to_s.camelize
        case event.to_sym
          when :touch
            #convert return to boolean
            wrapped_block = Proc.new { |*args| !!block.call(*args) }
          else
            wrapped_block = block
        end
        self.native.send(:"setOn#{listener_ref}Listener",_listener("On#{listener_ref}Listener", &wrapped_block))
      end

      protected

      def _listener(java_class, package = 'android.view.View' , &block)
        puts "using dexmaker auto wrapper"
        Proc.new { |*args|
          wrapped_args = args.collect { |a|
            wrap_native_view(a)
          }
          block.call(*wrapped_args)
        }
      end

    end
  end
end
