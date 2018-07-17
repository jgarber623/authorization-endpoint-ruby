require 'absolutely'
require 'addressable/uri'
require 'http'
require 'nokogiri'

require 'authorization_endpoint/version'
require 'authorization_endpoint/error'
require 'authorization_endpoint/client'
require 'authorization_endpoint/discover'
require 'authorization_endpoint/response'

module AuthorizationEndpoint
  def self.discover(url)
    Client.new(url).endpoint
  end
end
