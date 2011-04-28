require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class MajortomConnectorTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def setup_mock_for_config_file
    stub_request(:get,
          "http://your.majortom-server.com:8080/majortom-server/").
          to_return(:status => 200)
    MajortomConnector::Config.path_to_config_file = File.join(File.dirname(__FILE__), '..', 'examples', 'majortom-server.yml')
  end

  def test_connection_established_for_config_file
    setup_mock_for_config_file
    connection = MajortomConnector.connect
    assert connection.established?, "connection should be established"
    WebMock::stub_request :get, "http://your.majortom-server.com:8080/majortom-server/"
  end

  def test_connect_to_server_using_config_file_and_base_iri
    setup_mock_for_config_file


    #TODO should this be -> ist is because of calling against base-iri
    WebMock::stub_request(:get,
          "http://your.majortom-server.com:8080/majortom-server/tm/resolvetm?apikey=1a2b3c4d5e6f7g8h9i0j&bl=http://example.com/base_iri").
          to_return(:status => 200, :body => {:code => 0}.to_json)
    WebMock::stub_request(:get,
          "http://your.majortom-server.com:8080/majortom-server/tm/resolvetm?apikey=1a2b3c4d5e6f7g8h9i0j&bl=base:iri-should-be-valid").
          to_return(:status => 200, :body => {:code => 0}.to_json)


    connection = MajortomConnector.connect "http://example.com/base_iri"
    WebMock::assert_requested(:get,
      "http://your.majortom-server.com:8080/majortom-server/tm/resolvetm?apikey=1a2b3c4d5e6f7g8h9i0j&bl=http://example.com/base_iri")
    assert connection.ready?, "connection should be ready"
    assert connection.established?, "connection should be established"
    WebMock::assert_requested(:get, "http://your.majortom-server.com:8080/majortom-server/")


    
    connection = MajortomConnector.connect "base:iri-should-be-valid"
    assert connection.ready?, "connection should be ready"
    assert connection.established?, "connection should be established"
    WebMock::assert_requested(:get,
      "http://your.majortom-server.com:8080/majortom-server/tm/resolvetm?apikey=1a2b3c4d5e6f7g8h9i0j&bl=base:iri-should-be-valid")

  end

end