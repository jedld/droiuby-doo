class MockTemplateParser
  def initialize(template_name)
    @template_name = tempate_name
    @xml_content = Nokogiri.XML(File.read('config.droiuby'))
  end


end
