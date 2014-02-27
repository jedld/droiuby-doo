require 'java'

module JavaExtends

	def self.included(base)
    base.extend(ClassMethods)
  end

	def _ruby_object
		Java::org.jruby.javasupport.JavaUtil.convertJavaToRuby(_runtime, self)
	end

	def native
		@native
	end

	module ClassMethods

		def extend_java_class(klass)

			puts "creating auto proxy for #{klass}"
			klass_name = klass.to_s
			wrapper_klass = Java::com.droiuby.client.core.wrappers.InvocationHandlerRubyWrapper
			interface_generator = Java::com.droiuby.client.core.InterfaceGenerator
			converter = Java::org.jruby.javasupport.JavaUtil

			define_method(:_proxy_class) do |arg_types, arg_values|
				handler = wrapper_klass.new(_execution_bundle, _ruby_object, true)
				interface_generator.wrapperForInstance(_current_activity, klass_name, handler, arg_types, arg_values)
			end

			current_class = self

			define_method(:invoke) do |object, method, params|
	      method_name = method.getName.to_sym
	      if current_class.instance_methods(false).include? method_name
	      	native = object
	      	send(method_name, *params)
	      else
	      	Java::com.google.dexmaker.stock.ProxyBuilder.callSuper(object, method, params)
	    	end
	    end
	  end

	end

	private

	def native=(object)
		@native = object
	end

end
