class Object

  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
  
  def boolean?
    self.is_a?(TrueClass) || self.is_a?(FalseClass) 
  end
  
end
