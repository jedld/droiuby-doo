class Activity
  
  @@before_content_blocks = []

  def initialize
  end

  def me
    _current_activity
  end

  class << self

    def on_click(name, &block)
      view = V(name).tap { |v|
        v.native.setOnClickListener(Java::com.droiuby.client.core.OnClickListenerBridge.new(_execution_bundle, v.id))
      }
      define_method("on_click_listener_for_#{view.id.to_s}".to_sym) do |n_view|
        _current_activity.instance_exec(wrap_native_view(n_view),&block)
      end
    end
    
    def portrait_mode_only
      add_before_content_task { _current_activity.setRequestedOrientation(ActivityInfo::SCREEN_ORIENTATION_PORTRAIT) }  
    end

    def landscape_mode_only
      add_before_content_task { _current_activity.setRequestedOrientation(ActivityInfo::SCREEN_ORIENTATION_LANDSCAPE) }  
    end

    def no_action_bar
      add_before_content_task { _current_activity.requestWindowFeature(Java::android.view.Window::FEATURE_NO_TITLE) }
    end

    def set_theme(theme, namespace = nil)
      namespace = "#{namespace}." unless namespace.nil?

      add_before_content_task do  
        _current_activity.setTheme(_R("#{namespace}R.style.#{theme}"))
      end
    end

    private 

    def add_before_content_task(&block) 
      @@before_content_blocks = @@before_content_blocks || []
      @@before_content_blocks << block  
    end

  end

  def on_activity_result(request_code, result_code, intent)

  end
  
  def before_content_render
    @@before_content_blocks.each { |block| block.call }
    _current_activity.setContentView(_R('R.layout.canvas'))
  end

  def on_activity_reload
  end

end