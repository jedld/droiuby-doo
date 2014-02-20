class Fixnum

  def to_dp
    Java::com.droiuby.client.core.builder.ActivityBuilder.toDeviceIndependentPixels(_current_activity, self)    
  end
  
end
