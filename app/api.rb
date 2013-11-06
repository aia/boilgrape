$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'config'))

require 'rubygems'
require 'grape'
require 'json'
require 'boil-grape'

module BoilGrape
  class APIv1 < Grape::API
    version 'v1', :using => :path, :vendor => 'BoilGrape'
    format :json

  end
  
  class API < Grape::API
    rescue_from Grape::Exceptions::Validation do |e|
      Rack::Response.new(
        "Input Validation Exception: #{e.message}".to_json, 400
      )
    end
    
    rescue_from :all do |e|
      Rack::Response.new(
        "Unknown Error: #{e.message}".to_json, 500
      )
    end
    
    desc "Return service status"
    get "/status" do
      "OK"
    end
    
    mount BoilGrape::APIv1
  end
end
