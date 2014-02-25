class Fixnum

  def dip
    Java::com.droiuby.client.core.builder.ActivityBuilder.toDeviceIndependentPixels(_current_activity, self)    
  end

  def to_px
  	Java::com.droiuby.client.core.builder.ActivityBuilder.toPixelsFromDip(_current_activity, self)
  end

  def to_dip
  	(self / Java::com.droiuby.client.core.builder.ActivityBuilder.toDeviceIndependentPixels(_current_activity, 1))
  end
  
end
