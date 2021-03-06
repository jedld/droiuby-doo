class CompoundButtonWrapper < ViewWrapper
  
  
  def on(event,&block)
    listener_ref = event.to_s.camelize
    case event.to_sym
      when :checked_change
        self.native.send(:"setOn#{listener_ref}Listener",_listener("On#{listener_ref}Listener", 'android.widget.CompoundButton', &block))
      else
        super(event, &block)
    end
  end
  
  def checked?
    self.native.isChecked
  end
  
  def checked=(value)
    self.native.setChecked(value)
  end
  
  
end
