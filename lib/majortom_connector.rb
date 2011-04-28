require 'majortom_connector/config'
require 'majortom_connector/connector'
require 'majortom_connector/result'
require 'majortom_connector/request'

module MajortomConnector
  
  def self.connect(configuration = "")
    return Connector.new(configuration) if configuration.is_a? String

    config = Config.load_server_config_from_file(opts[:config_file]) if opts[:config_file]


  end

end
