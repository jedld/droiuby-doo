require 'rubygems'
require 'net/http'
require 'net/http/post/multipart'
require 'zip'
require 'thor'
require "uri"
require 'cgi'
require 'nokogiri'
require 'droiuby/support/object'
require 'droiuby/support/string'

class Project < Thor

  include Thor::Actions

  source_root File.join(File.dirname(__FILE__), 'templates')

  no_commands {
    def map_device_ip(device_ip)
      if device_ip.nil?
        device_ip = '127.0.0.1'
        begin
        `adb forward tcp:4000 tcp:4000`
        rescue Exception=>e
          puts e.inspect
        end
      end
      device_ip
    end

    def ignore_path?(fpath)
        [/^build/, /^project/, /^vendor\/cache/, /^vendor\/(.*)\/tasks/,
          /^vendor\/(.*)\/ext/, /^vendor\/(.*)\/test/, /^vendor\/(.*)\/port/,
          /^vendor\/(.*)\/bin/].each do |r|
          return true if fpath.match(r)
        end
        return false
    end

    def get_connected_devices
      begin
        output = `adb devices`
        lines = output.split("\n")
        lines.shift 1
        lines.reject { |line| line.strip.empty? }.collect { |line| line.split(' ').first }
      rescue Errno::ENOENT => e
        []
      end
    end

    def project_generator(name, app_name = :prompt, output_dir = 'projects', opt={})
      @name = name
      if app_name.nil?
        @app_name = app_name
      elsif app_name == :prompt
        say("Please enter the display name for your app (Used for app launcher and Title):")
        @app_name = ask("Display Name: ")
      end

      @description = name
      @launcher_icon = ''
      @base_url = ''
      if opt[:type] == :droiuby
        @main_xml = File.join("app","views","index.xml")
      elsif opt[:type] == :hybrid
        @main_xml = File.join("app","activities","index.rb")
      else
        say :red, "Invalid project type specified #{opt[:type]}"
        exit(1);
      end

      if output_dir.blank?
        output_dir = Dir.pwd
      end

      dest_folder = File.join(output_dir,"#{name}")
      template File.join('ruby','Gemfile.erb'), File.join(dest_folder,"Gemfile")
      template File.join('ruby','config.droiuby.erb'), File.join(dest_folder,"config.droiuby")
      template File.join('ruby','gitignore.erb'), File.join(dest_folder,".gitignore")

      if opt[:type] == :droiuby
        template File.join('ruby','index.xml.erb'), File.join(dest_folder,"app","views","index.xml")
      end

      template File.join('ruby','application.css.erb'), File.join(dest_folder,"app","views","styles","application.css")
      if opt[:type] == :droiuby
        template File.join('ruby','index.rb.erb'), File.join(dest_folder,"app","activities","index.rb")
      elsif opt[:type] == :hybrid
        template File.join('ruby','index-hybrid.rb.erb'), File.join(dest_folder,"app","activities","index.rb")
      end
      template File.join('ruby','index_spec.rb.erb'), File.join(dest_folder,"spec","activities","index_spec.rb")
      template File.join('ruby','spec_helper.rb.erb'), File.join(dest_folder,"spec","spec_helper.rb")

      empty_directory File.join(dest_folder,"lib")

      Dir.chdir dest_folder
      if opt[:type] == :hybrid
        template_generator(nil, :prompt, nil,  nil, {xoptions: {hybrid: true}})
      elsif opt[:standalone] == true
        template_generator(nil, :prompt, nil,  nil, nil, nil)
      end

      say "running bundle install"
      `bundle install`
    end

    def template_generator(name, package_name, title = nil, output_dir = 'projects', options = {})

      repository = options[:repository] || nil
      branch = options[:branch] || nil

      if output_dir.blank?
        output_dir = Dir.pwd
      end

      if package_name == :prompt
        say("Please enter the Java Package Name to be used for your app (e.g. com.awesome.sample ):")
        package_name = ask("Package Name: ")
      end

      dest_folder = nil
      unless name.nil?
        dest_folder = File.join(output_dir,"#{name}")
        Dir.chdir dest_folder
      else
        dest_folder = Dir.pwd
      end

      if title.nil?

        doc = Nokogiri.XML(File.read('config.droiuby'))

        doc.css('app_descriptor name').each do |element|
          title = element.content
        end

      end

      template_repository = ENV['droiuby_template'] || repository || 'https://github.com/jedld/droiuby-template.git'
      template_directory = File.expand_path("~/.droiuby/android_project_templates.#{branch.nil? ? 'master' : branch}")

      unless File.exists?(template_directory)
        say "no cached copy yet. obtaining template project from repository"

        branch = unless branch.nil?
          "-b #{branch}"
        else
          ""
        end

        `git clone #{branch} --depth 1 #{template_repository} #{template_directory}`
      else
        say "checking for template updates..."
        Dir.chdir template_directory
        `git pull`
      end

      #prepare
      directory template_directory, File.join(dest_folder,'project')
      remove_dir "#{File.join(dest_folder,'project')}/.git"

      Dir.chdir File.join(dest_folder,'project')

      say "creating android porject in #{dest_folder}"
      require "#{File.join(dest_folder,'project','init.rb')}"

      dest_folder = if dest_folder.end_with? '/'
        dest_folder
      else
        "#{dest_folder}/"
      end

      archive_name = File.basename(dest_folder.sub!(%r[/$],'')) if archive_name.nil?

      init = Init.new
      init.options = options[:xoptions]
      init.init(package_name, "#{archive_name}.zip", title)
      Dir.chdir dest_folder
      bundle
      package(name, '', "true")
      say "Your android project is located at #{dest_folder}/project."
    end


  }


  desc "proximity [device_ip] [true|false]", "enable/disable proximity refresh"
  def proximity(device_ip, proximity = 'false')
    device_ip = map_device_ip(device_ip)
    url_str = "http://#{device_ip}:4000/control?cmd=proximity&switch=#{proximity}"
    uri = URI.parse(url_str)
    # Shortcut
    response = Net::HTTP.get_response(uri)
    response.body
  end

  desc "launch device IP [URL]","Tell droiuby to connect to app hosted at URL"
  def launch(device_ip, url)

    device_ip = map_device_ip(device_ip)

    url_str = "http://#{device_ip}:4000/control?cmd=launch&url=#{CGI::escape(url)}"
    puts "loading application at url #{url}"
    puts url_str
    uri = URI.parse(url_str)
    # Shortcut
    response = Net::HTTP.get_response(uri)
    # Will print response.body
    Net::HTTP.get_print(uri)
  end

  desc "list [DEVICE IP]","List running app instances"
  def list(device_ip = nil)
    device_ip = map_device_ip(device_ip)
    url_str = "http://#{device_ip}:4000/control?cmd=list"
    puts url_str
    uri = URI.parse(url_str)
    # Shortcut
    response = Net::HTTP.get_response(uri)
    result = JSON.parse(response.body)
    result['list'].split(',').each do |item|
      puts item
    end
  end

  desc "cmd [command] [DEVICE_IP]", "Send command to a Droiuby instance"
  def command(command_line, device_ip=nil)
    device_ip = map_device_ip(device_ip)
    url_str = "http://#{device_ip}:4000/console?cmd=#{CGI::escape(command_line)}"
    uri = URI.parse(url_str)
    # Shortcut
    response = Net::HTTP.get_response(uri)
    response.body
  end

  desc "reload [DEVICE_IP]", "Reload app at specified device"
  def reload(device_ip = nil)
    device_ip = map_device_ip(device_ip)
    url_str = "http://#{device_ip}:4000/control?cmd=reload"
    uri = URI.parse(url_str)
    # Shortcut
    response = Net::HTTP.get_response(uri)
    response.body
  end

  desc "switch [name] [DEVICE IP]","switch to target app instance identified by name"
  def switch(name, device_ip = nil)
    device_ip = map_device_ip(device_ip)
    url_str = "http://#{device_ip}:4000/control?cmd=switch&name=#{CGI::escape(name)}"
    puts url_str
    uri = URI.parse(url_str)
    # Shortcut
    response = Net::HTTP.get_response(uri)
    # Will print response.body
    response = Net::HTTP.get_print(uri)
  end

  desc "autostart MODE [NAME] [DEVICE IP]","set current app to load on startup"
  def autostart(mode = 'on', name = nil, device_ip = nil)
    device_ip = map_device_ip(device_ip)
    url_str = if mode == 'on'
      "http://#{device_ip}:4000/control?cmd=autostart#{!name.nil? ? "&name=#{CGI::escape(name)}" : ''}"
    else
      "http://#{device_ip}:4000/control?cmd=clearautostart"
    end

    puts url_str
    uri = URI.parse(url_str)
    # Shortcut
    response = Net::HTTP.get_response(uri)
    # Will print response.body
    Net::HTTP.get_print(uri)

  end

  desc "standalone NAME [PACKAGE_NAME]", "create an android project for this app with the specified java package name"
  method_option :xoptions, :type => :hash, :default => {}
  def standalone(name, package_name, title = nil, output_dir = 'projects', repository = nil, branch = nil)
    options[:repository] = respository
    options[:branch] = branch
    template_generator(name, package_name, title , output_dir , options)
  end


  desc "create PROJECT_NAME [APP_NAME] [WORKSPACE_DIR]","create a new droiuby project with NAME"

  def create(name, app_name = :prompt, output_dir = 'projects', type = 'droiuby')
      opt =  {type:  type.to_sym}
      project_generator(name, app_name, output_dir, opt)
  end

  desc "package NAME [WORKSPACE_DIR] [true|false]","package a project"

  def package(name, source_dir = 'projects', force = "false")
    src_folder = if name.blank?
      Dir.pwd
    else
      File.join(source_dir, name)
    end

    say "compress #{src_folder}"
    archive = compress(src_folder, force)

    project_directory = File.join(src_folder,'project')
    say "exsits? #{project_directory}"
    if File.exists? project_directory
      say "Android Project exists. Updating build inside assets ..."
      copy_file archive, File.join(project_directory,'assets',File.basename(archive)), force: true
    end
  end

  require 'webrick'
  include WEBrick

  desc "live NAME DEVICE_IP [HOST NAME] [SOURCE]", "Allow live editing of apps by starting a web server and pointing droiuby to the local instance"

  def live(name, device_ip = nil, host_name = nil, source_dir = 'projects')

    source_dir_args = source_dir ? source_dir : 'projects'
    host_name_args = host_name ? host_name : Socket.gethostname

    src_dir = if name.blank?
      Dir.pwd
    else
      File.join(source_dir_args, name)
    end

    device_ip = map_device_ip(device_ip)

    port = 2000

    ready = false

    Thread.new do
      while !ready
      end
      begin
        launch(device_ip, "http://#{host_name_args}:#{port}/config.droiuby")
      rescue Exception=>e
        `adb shell am start -W -S --activity-clear-top --activity-brought-to-front -n com.droiuby.application/.DroiubyActivity`
      end
    end

    puts "Starting server: http://#{host_name_args}:#{port}"
    puts "Document root #{src_dir}"
    server = HTTPServer.new(:Port=>port,:DocumentRoot=> src_dir,:StartCallback => Proc.new {
      ready = true
    })
    trap("INT"){ server.shutdown }
    server.start
  end

  desc "upload NAME DEVICE_IP [WORKSPACE_DIR]","uploads a droiuby application to target device running droiuby client"

  def upload(name, device_ip, source_dir = 'projects', framework = false, run = true)

    source_dir = if name.blank? || framework
      Dir.pwd
    else
      File.join(source_dir, name)
    end

    device_ip = map_device_ip(device_ip)

    src_package = if framework
      File.join(source_dir,'framework_src','build',"#{name}.zip")
    elsif !name.blank?
      File.join(source_dir,name,'build',"#{name}.zip")
    else
      name = File.basename(source_dir)
      File.join(source_dir,'build',"#{name}.zip")
    end

    url_str = "http://#{device_ip}:4000/upload"
    uri = URI.parse(url_str)
    say "uploading #{src_package} to #{url_str} -> #{uri.host}:#{uri.port}"
    File.open(src_package) do |zip|

      params = {
        "name" => name,
        "run" => run ? 'true' : 'false',
        "file" => UploadIO.new(zip, "application/zip", src_package,"content-disposition" => "form-data; name=\"file\"; filename=\"#{File.basename(src_package)}\"\r\n")}


      params.merge!(framework: 'true') if framework
      req = Net::HTTP::Post::Multipart.new uri.path, params

      retries = 0
      res = nil

      while (retries < 3)
        sleep 1 + retries
        begin
          res = Net::HTTP.start(uri.host, uri.port) do |http|
            http.request(req)
          end
          break
        rescue Errno::EHOSTUNREACH
          retries += 1
          next
        end
      end

      if res && res.code == "200"

        say_status 'upload', src_package
      else
        if res
          say_status 'upload','res.body', :red
        else
          say_status 'upload',"upload failed. cannot connect to #{url_str}", :red
        end

      end

    end
  end

  desc "framework DEVICE_IP","updates the droiuby framework using code from framework_src"
  def framework(device_ip = nil, source_dir = 'framework_src')
    compress(source_dir, "true", "framework")
    upload 'framework', device_ip, File.join(Dir.pwd,"framework_src"), true
  end

  desc "execute NAME DEVICE_IP [WORKSPACE_DIR] [IGNORE_PROJECT] [ANT_ARGS]","package and execute a droiuby application to target device running droiuby client"
  def execute(name, device_ip, source_dir = 'projects', ignore_project = false, ant_args = nil)

    package name, source_dir, "true"

    source_dir_args = source_dir ? source_dir : 'projects'
    src_dir = if name.blank?
      Dir.pwd
    else
      File.join(source_dir_args, name)
    end

    project_directory = File.join(src_dir,'project')

    say "exsits? #{project_directory}"
    if !ignore_project && File.exists?(project_directory)
      say "Android Project exists. Building debug project instead ..."
      Dir.chdir(project_directory)
      doc = Nokogiri.XML(File.read('AndroidManifest.xml'))

      package_name = nil
      doc.css('manifest').each do |element|
        package_name = element['package']
      end

      say "running ant debug install"
      if !get_connected_devices.empty?
        puts `ant debug install`
        say "Starting activity #{package_name}"
        `adb shell am start  -S --activity-clear-top --activity-brought-to-front -n #{package_name}/.StartupActivity`
      else
        say "No device connected. will just build the project"
        if ant_args.nil?
          puts `ant debug`
        else
          puts `ant #{ant_args}`
        end
      end
    else
      upload name, device_ip, source_dir
    end

  end

  desc "bundle", "unpack all cached gems"

  def bundle
    cache_dir = File.join('vendor','cache')

    unless Dir.exists?(cache_dir)
      puts `bundle package --all`
    end

    if Dir.exists?(cache_dir)
      path = cache_dir
      puts 'watch out for exploding gems'
      Dir["#{path}/*.gem"].each do |file|
        say_status 'unpack', file
        `gem unpack #{file} --target ./vendor`
      end
    else
      say_status 'error', "can't find cache directory /vendor/cache"
    end


  end

  private

  def compress(path, force = "false", archive_name = nil)
    path.sub!(%r[/$],'')
    unless Dir.exists?(File.join(path,'build'))
      Dir.mkdir(File.join(path,'build'))
    end

    archive_name = File.basename(path) if archive_name.nil?


    archive = File.join(path,'build',"#{archive_name}.zip")

    if force=='true' || file_collision(archive)

      FileUtils.rm archive, :force=>true

      Zip::File.open(archive, Zip::File::CREATE) do |zipfile|
        Dir.glob("**{,/*/**}/*.*").reject{ |f| f==archive || ignore_path?(f) }.uniq.each do |file|
          say_status 'adding', file
          begin
            zipfile.add(file, file)
          rescue Zip::ZipEntryExistsError=>e
          end
        end
      end
      say_status 'create', archive
    end

    archive
  end
end
