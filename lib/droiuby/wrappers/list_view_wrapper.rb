class ListViewWrapper < ViewGroupWrapper

  def initialize(view = nil)
    if view.nil?
      @view = Java::android.widget.ListView.new(_current_activity)
    else
      super(view)
    end
  end

  def set_adapter(adapter)
    @native.setAdapter(adapter.native)
  end
end
