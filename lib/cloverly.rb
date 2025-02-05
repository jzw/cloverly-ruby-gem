require 'faraday'
require 'json'

class Cloverly
  attr_reader :api_key

  class << self
    def default=(cloverly)
      @@default = cloverly
    end

    def default
      @@default
    end

    def account
      Cloverly::Account.parse(default, default.get('/2019-03-beta/account'))
    end

    def estimate_offset(type, args = {})
      Cloverly::Estimate.parse(default, default.post("/2019-03-beta/estimates/#{type}", args))
    end

    def offset(type, args = {})
      Cloverly::Purchase.parse(default, default.post("/2019-03-beta/purchases/#{type}", args))
    end
  end

  def initialize(api_key)
    @api_key = api_key
  end

  def account
    Cloverly::Account.parse(self, get('/2019-03-beta/account'))
  end

  def estimate_offset(type, args = {})
    Cloverly::Estimate.parse(self, post("/2019-03-beta/estimates/#{type}", args))
  end

  def offset(type, args = {})
    Cloverly::Purchase.parse(self, post("/2019-03-beta/purchases/#{type}", args))
  end

  def post(path, data)
    response = conn.post do |req|
      req.url path
      req.body = data.to_json
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{api_key}"
    end

    json_response = JSON.parse(response.body)

    if json_response["error"].nil?
      json_response
    else
      raise Cloverly::Error.new(json_response["error"])
    end
  end

  def get(path)
    response = conn.get do |req|
      req.url path
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{api_key}"
    end

    json_response = JSON.parse(response.body)

    if json_response.is_a?(Array) || json_response["error"].nil?
      json_response
    else
      raise Cloverly::Error.new(json_response["error"])
    end
  end

  def delete(path)
    response = conn.delete do |req|
      req.url path
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{api_key}"
    end

    json_response = JSON.parse(response.body)

    if json_response.is_a?(Array) || json_response["error"].nil?
      json_response
    else
      raise Cloverly::Error.new(json_response["error"])
    end
  end

  private
  def conn
    @conn ||= Faraday.new(:url => ENV['CLOVERLY_API_URL'] || 'https://api.cloverly.app')
  end
end

require_relative './cloverly/base'
require_relative './cloverly/error'
require_relative './cloverly/account'
require_relative './cloverly/estimate'
require_relative './cloverly/purchase'
require_relative './cloverly/source'
