# frozen_string_literal: true

require "rack/url_query_key_validator/version"

module Rack
  #
  # Rack Middleware for URL Query Params Key Validator
  #
  class UrlQueryKeyValidator
    #
    # @param [Object] app - Rack application
    # @param [Hash] options - Options for validation
    #
    def initialize(app, options = {})
      @app = app
      @invalid_key = options[:invalid_key] || "amp;"
      @max_allowed = options[:max_allowed] || 3
      @logger = options[:logger] if options[:logger]
    end
    attr_reader :invalid_key, :max_allowed, :logger

    #
    # @param [Hash] url - Query parameters
    #
    def valid?(url)
      regex = /(#{invalid_key}){#{max_allowed + 1},}/

      url.scan(regex).empty?
    end

    #
    # @param [Hash] env - Rack environment
    #
    def call(env)
      req = Rack::Request.new(env)

      if valid?(req.url)
        @app.call(env)
      else
        logger&.send(:error, "Invalid uri is #{req.url}")
        [400, { "Content-Type" => "text/plain" }, ["Bad Request"]]
      end
    end
  end
end
