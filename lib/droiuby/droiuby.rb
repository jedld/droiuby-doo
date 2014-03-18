require 'droiuby/loader'

#Droiuby Framework class
class DroiubyFramework

  def before_activity_setup
    fname = "#{File.dirname(__FILE__)}/bootstrap.rb"
    @bootstrap = @bootstrap || File.read(fname)
    eval(@bootstrap, TOPLEVEL_BINDING, fname, __LINE__)
  end

  def preload
    fname = "#{File.dirname(__FILE__)}/preload.rb"
    @preload = @preload || File.read(fname)
    eval(@preload, TOPLEVEL_BINDING, fname, __LINE__)
  end

  def on_click(view)
  end

  def script(controller, refresh = false)
    klass = controller.camelize.constantize
    instance = klass.new

    skip_content_view = if instance.respond_to? :before_content_render
      instance.before_content_render unless refresh
    end

    set_content_view unless skip_content_view

    instance.on_create
    instance
  end

  def resolve_view(name, node)
    name_parts = name.split('#')

    klass_str = if name_parts.size > 1
      "#{name_parts[0].camelize}::#{name_parts[1].camelize}"
    else
      name.camelize
    end

    puts klass_str
    klass = klass_str.constantize

    instance = klass.new(_current_activity)
    if instance.class < ViewWrapper
      instance.native
    else
      instance._proxy_class([Java::android.content.Context.java_class], [_current_activity])
    end
  end

end

$framework = DroiubyFramework.new
