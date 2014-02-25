require 'java'

JObject = java.lang.Object

class JObject

	def _ruby_object
		Java::org.jruby.javasupport.JavaUtil.convertJavaToRuby(_runtime, self)
	end

	def self.inherited(klass)

		puts "creating auto proxy for #{klass}"
		klass_name = self.java_class.to_s
		wrapper_klass = Java::com.droiuby.client.core.wrappers.InvocationHandlerRubyWrapper
		interface_generator = Java::com.droiuby.client.core.InterfaceGenerator
		converter = Java::org.jruby.javasupport.JavaUtil

		define_method(:_proxy_class) do
			
			handler = wrapper_klass.new(_execution_bundle, _ruby_object)
			interface_generator.wrapperForClass(_current_activity, klass_name, handler)
		end
  end
end
