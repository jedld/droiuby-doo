class String
  
  def camelize(first_letter_in_uppercase = true)
    if first_letter_in_uppercase
      self.to_s.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
    else
      self.first + camelize(self)[1..-1]
    end
  end
  
  def to_pixels
    Java::com.droiuby.client.core.builder.ActivityBuilder.toPixels(_current_activity, self)
  end
  
  def to_color
    Java::android.graphics.Color.parseColor(self)
  end
  
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
  
  def constantize
    names = self.split('::')
    names.shift if names.empty? || names.first.empty?
    index = 1
    names.inject(Object) do |constant, name|
      if constant == Object
        constant.const_get(name)
      else
        begin
          candidate = constant.const_get(name)
        rescue NameError => e
          Object.const_missing(names[0..index].join('::'))
          candidate = constant.const_get(name)
        end
        index += 1
        next candidate if constant.const_defined?(name, false)
        next candidate unless Object.const_defined?(name)

        # Go down the ancestors to check it it's owned
        # directly before we reach Object or the end of ancestors.
        constant = constant.ancestors.inject do |const, ancestor|
          break const    if ancestor == Object
          break ancestor if ancestor.const_defined?(name, false)
          const
        end

        # owner is in Object, so raise
        constant.const_get(name, false)

      end
    end
  end
  
end
