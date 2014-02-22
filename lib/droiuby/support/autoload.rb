$autoload_path = [nil,File.join('droiuby','wrappers')]

class Object
  class << self
    alias :const_missing_old :const_missing
    def const_missing(name)
      puts "constant missing #{name}"
      @looked_for ||= {}
      str_name = name.to_s
      raise "Class not found: #{name}" if @looked_for[str_name]
      @looked_for[str_name] = 1
      
      name_parts = name.to_s.split('::').collect { |n| n.underscore }
      
      
      $autoload_path.each do |path|
        path_array = unless path.nil? 
          [path] + name_parts
        else
          name_parts
        end 
        require_path = File.join(*path_array)
        puts "autoloading #{require_path}"

        begin
          require require_path
          klass = const_get(name)
          return klass if klass
        rescue LoadError=>e
        end
        
      end

      raise "Class not found: #{name}"
    end
  end
end
