require 'droiuby/wrappers/view_wrapper'

class EditTextWrapper < TextViewWrapper
  
  java_attr_accessor :hint
  
  def text=(text)
      @view.setText(text)
  end
  
  def text
      @view.getText.toString
  end
  
  def color=(value)
    @view.setTextColor(value)
  end
  
  def color
    @view.getTextColors.getDefaultColor
  end
end