module HamlAssets
  class Engine < ::Rails::Engine
    initializer "sprockets.hamljs", :after => "sprockets.environment", :group => :all do |app|
      config.assets.configure do |env|
        if env.respond_to?(:register_transformer)
          env.register_mime_type 'text/hamljs', extensions: ['.hamljs']
          env.register_transformer 'text/hamljs', 'application/javascript', ::HamlAssets::HamlSprocketsEngine
        end

        if env.respond_to?(:register_engine)
          args = ['.hamljs', ::HamlAssets::HamlSprocketsEngine]
          args << { mime_type: 'text/hamljs', silence_deprecation: true } if Sprockets::VERSION.start_with?('3')
          env.register_engine(*args)
        end
      end
    end
  end
end

module HamlAssets
  class Railtie < ::Rails::Railtie
    if ::Rails.version.to_f >= 3.1
      config.app_generators.javascript_template_engine :haml
    end
  end
end
