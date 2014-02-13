class ViewArray
  
  def initialize(elements = [])
    @elements = elements
  end
  
  def method_missing(meth, *args, &block)
    @elements.send(meth, *args, &block)
  end
        
  def on(symbol, &block)
    @elements.each { |elem|
      elem.on(symbol, &block)
    }
  end
  
  def to_a
    @elements
  end
  
end