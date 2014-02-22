module Droiuby
  class Android
    class Otherwise
      
      def initialize
      end
      
      def otherwise(&block)
        @return_value = block.call
      end
      
      def value
        @return_value
      end
    end

    class DummyOtherwise
      
      def initialize(return_value)
        @return_value = return_value
      end
      
      def otherwise(&block)
        @return_value
      end
      
      def value
        @return_value
      end
    end

    def self.when_api(verb, level, &block)
      current_api_level = Java::android.os.Build::VERSION::SDK_INT
      case verb.to_sym
      when :is
        return DummyOtherwise.new(block.call) if current_api_level == level
      when :greater_than
        return DummyOtherwise.new(block.call) if current_api_level > level
      when :less_than
        return DummyOtherwise.new(block.call) if current_api_level < level
      when :at_least
        return DummyOtherwise.new(block.call) if current_api_level >= level
      when :at_most
        return DummyOtherwise.new(block.call) if current_api_level <= level
      end
      return Otherwise.new
    end

  end
end