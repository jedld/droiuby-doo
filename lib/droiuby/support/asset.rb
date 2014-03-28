class BitmapDrawableWrapper
  def initialize(drawable)
    @native = drawable
  end

  def native
    @native
  end

  def to_bitmap
    @native.getBitmap
  end

  def height
    @native.getIntrinsicHeight
  end

  def width
    @native.getIntrinsicWidth
  end
end

class AssetHandler

  def initialize(url, asset_type)
    @url = url
    @asset_type = case asset_type
      when :image
        Java::com.droiuby.client.core.utils.Utils::ASSET_TYPE_IMAGE
      end

  end

  def self.download(url, asset_type = :image)
    AssetHandler.new(url, asset_type)
  end

  def start
    async.perform {
      result = BitmapDrawableWrapper.new(Java::com.droiuby.client.core.utils.Utils.loadAppAssetRuby(_execution_bundle, _current_app, _current_activity,
      @url, @asset_type, Java::com.droiuby.client.core.utils.Utils::HTTP_GET))
      result
    }.done { |result|
      @block.call(result)
    }.start
  end

  def done(&block)
    @block = block
    self
  end
end
