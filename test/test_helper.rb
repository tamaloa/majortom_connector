require 'test/unit'
require 'webmock/test_unit'

require File.join(File.dirname(__FILE__), '..', 'lib', 'majortom_connector')

WebMock::stub_request(:any, "www.example.com")

WebMock::stub_http_request(:post, "www.example.com").
    with(:body => {:data => {:a => '1', :b => 'five'}})
