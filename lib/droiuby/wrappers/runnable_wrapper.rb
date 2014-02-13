class RunnableWrapper
  
  def initialize(block)
    @block = block
    @native = Java::com.droiuby.wrappers.RunnableRubyWrapper.new(_execution_bundle,self)
  end
  
  def run
    @block.call
  end
  
  def to_native
    @native
  end
  
end