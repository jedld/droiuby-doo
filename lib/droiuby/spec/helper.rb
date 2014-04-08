$:.unshift Dir.pwd

require File.join(File.dirname(__FILE__),'loader')
$autoload_path << File.join('app','activities')
$working_directory = Dir.pwd

Dir[File.join("#{File.dirname(__FILE__)}",'mock_objects','java_classes',"*.rb")].each {|f| require f}
Dir[File.join("#{File.dirname(__FILE__)}",'mock_objects',"*.rb")].each {|f| require f}


class Java

  class Stubber
    def RubyContainerPayload
      MockObjects::JavaClasses::RubyContainerPayload.new
    end
  end

  def self.droiuby
    self
  end

  def self.client
    self
  end

  def self.core
    Stubber.new
  end

  def self.com
    self
  end

end

#Droiuby Mock Framework class
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

def set_mock_environment(environment = nil)
  puts "new environment"
  if environment.nil?
  doc = Nokogiri.XML(File.read('config.droiuby'))

    title = ''
    params = {}
    doc.css('app_descriptor').tap do |e|
      %w[name description base_url main framework].each do |attr|
        params[attr.to_sym] = e.css(attr).first.content
      end
    end

    $mock_environment = MockEnvironment.new(params)
  else
    $mock_environment = environment
  end
  $mock_environment
end
