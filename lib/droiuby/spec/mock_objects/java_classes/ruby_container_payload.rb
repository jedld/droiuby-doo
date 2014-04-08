module MockObjects
  module JavaClasses

    class RubyContainerPayload

      def java_method(method, params)
        puts "method #{method} : #{params.inspect}"
      end

      def getExecutionBundle
        MockObjects::JavaClasses::ExecutionBundle.new
      end

    end

  end
end
