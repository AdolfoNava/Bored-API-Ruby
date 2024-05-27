require "minitest/autorun"
require "http"
require 'test/unit'
require 'rack/test'
require './app'
class Test::Unit::TestCase
  include Rack::Test::Methods
end

class TestSearch < Test::Unit::TestCase
  def test_successful_attempt
    get '/wordResults', :word => 'test'
    assert last_response.body.include?(
      "<h1>Word searched: Test></h1>")
  end

end
