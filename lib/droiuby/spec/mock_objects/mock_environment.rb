class MockEnvironment
  
  attr_accessor :current_app, :app_name, :base_url, :main_url

  def initialize(params = {})
    @current_app = DroiubyApp.new
    @app_name = params[:app_name] || ''
    @base_url = params[:base_url] || ''
    @main_url = params[:main_url] || ''
    @mock_view_heirarchy = []
  end

  def before_setup(activity_instance, template)
    if (activity_instance.kind_of? Activity)
      $framework.before_activity_setup
    else
        doc = Nokogiri.XML(File.read(template))

        doc.css('app_descriptor name').each do |element|
          title = element.content
        end

    end
  end

  def on_create(activity_instance, refresh = false)
    skip_content_view = if activity_instance.respond_to? :before_content_render
      activity_instance.before_content_render unless refresh
    end

    set_content_view unless skip_content_view

    instance.on_create
    instance
  end
end
