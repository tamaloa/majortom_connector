module MajortomConnector
  class Connector
    
    def initialize(id_or_base_iri, configuration = Config.new)
      @config = configuration
      return unless ready?
      #until now we use URI to check for valid base_iri ... compliant to standard tmdm we would have to
      #support any locator notation -> any string
      config.map_id = id_or_base_iri.match(URI::regexp) ? find_topic_map_id_by_base_iri(id_or_base_iri) : id_or_base_iri
    end
    
    def topic_map_id
      config.map_id ||= ""
    end
  
    def list_maps
      request.run('topicmaps') if ready?
    end
  
    def find_topic_map_id_by_base_iri(base_iri)
      request.run('resolvetm', base_iri).data if ready?
    end
  
    def topics
      request.run('topics') if ready?
    end
  
    def tmql(query)
      request.run('tmql', query) if ready?
    end
  
    def sparql(query)
      request.run('sparql', query) if ready?
    end
  
    def search(query = "")
      request.run('beru', query) if ready?
    end
  
    def to_xtm
      request.run('xtm') if ready?
    end
  
    def to_ctm
      request.run('ctm') if ready?
    end
    
    def clear_cache
      request.run('clearcache') if ready?
    end
  
    def ready?
      config.ready?
    end
    
    def established?
      ready? && request.run('connectiontest').code == "0"
    end
    
    def request
      @request ||= Request.new(config)
    end
  
    def config
      @config ||= Config.new
    end
  end
end
