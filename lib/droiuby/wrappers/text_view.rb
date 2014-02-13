require 'droiuby/wrappers/view_wrapper'

class TextViewWrapper < ViewWrapper
  
  java_attr_accessor :cursor_visible, :text_color, :text_scale_x
  
  def text=(text)
      @view.setText(text.to_s)
  end
  
  def text
      @view.getText
  end
  
  def text_size=(size)
    @view.setTextSize(Java::android.util.TypedValue::COMPLEX_UNIT_DIP,size.to_f)
  end
  
  def text_color
    @view.getCurrentTextColor
  end
  
  def text_color=(value)
    @view.setTextColor(parse_color(value));
  end 
  
  
end