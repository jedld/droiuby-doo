class AnimatorListenerWrapper

  def initialize
    @native = Java::com.droiuby.wrappers::AnimatorListenerRubyWrapper.new(_execution_bundle, self)
    @blocks = {}
  end

  def set_block(sym, &block)
    @blocks[sym.to_sym] = block
  end

  def onAnimationStart
    @block[:start].call if @block.has_key? :start
  end

  def onAnimationEnd
    @block[:end].call if @block.has_key? :end
  end

  def onAnimationCancel
    @block[:cancel].call if @block.has_key? :cancel
  end

  def onAnimationRepeat
    @block[:repeat].call if @block.has_key? :repeat
  end

  def to_native
    @native
  end
end
