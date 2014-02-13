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

  def script(controller)
    klass = controller.camelize.constantize
    instance = klass.new

    skip_content_view = if instance.respond_to? :before_content_render
      instance.before_content_render
    end

    set_content_view unless skip_content_view

    instance.on_create
    instance
  end

  def resolve_view(name, node)
    klass = name.constantize
    instance = klass.new
    if instance < ViewWrapper
      instance.native
    else
      instance
    end
  end

end

$framework = DroiubyFramework.new