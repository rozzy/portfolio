require "./app"

configure do
  set :environment, :development
  
  set :root, File.dirname(__FILE__)
  set :views, Proc.new { File.join(root, "views/") }
  set :public_folder, Proc.new { File.join(root, "public") }
  
  Slim::Engine.set_default_options pretty: (settings.environment == :development ? true : false), sort_attrs: true

  Compass.configuration do |config|
    settings.environment == :production ? 
      config.output_style = :compressed : 
      config.output_style = :nested
    settings.environment == :development ?
      config.line_comments = true :
      config.line_comments = false
  end

  set :sass, Compass.sass_engine_options
end

run Blog