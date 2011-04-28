module MajortomConnector
  class Config
    
    attr_accessor :host, :port, :context, :api_key, :map_id
    
    def initialize
      load_server_config_from_file
    end

    def ready?
      !(@host.blank? || @port.blank? || @context.blank? || @api_key.blank?)
    end

    def self.path_to_config_file=(path)
      @@config_file = path
    end
        
    def load_server_config_from_file
      if File.exists? config_file
        file_config = YAML.load_file(config_file)
        @host = file_config['server']['host']
        @port = file_config['server']['port']
        @context = file_config['server']['context']
        @api_key = file_config['user']['api_key']
      else
        #TODO return error message with message explaining where to put config file
      end
    end

    def config_file
      @@config_file || File.join(::Rails.root, 'config', 'majortom-server.yml')
    end
  end
end
