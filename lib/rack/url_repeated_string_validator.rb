# frozen_string_literal: true

require "rack/url_repeated_string_validator/version"

module Rack
  #
  # Rack Middleware for URL Query Params Key Validator
  #
  class UrlRepeatedStringValidator
    DEFAULT_INVALID_KEYS = ["amp;"].freeze
    MAX_REPEATED = 3
    #
    # @param [Object] app - Rack application
    # @param [Hash] options - Options for validation
    #
    def initialize(app, options = {})
      @app = app
      @invalid_keys = options[:invalid_keys] || DEFAULT_INVALID_KEYS
      @max_repeated = options[:max_repeated] || MAX_REPEATED
      @logger = options[:logger] if options[:logger]
    end
    attr_reader :invalid_keys, :max_repeated, :logger

    #
    # @param [String] url
    # @return [Boolean]
    #
    def valid?(url)
      invalid_keys.map { |key| url.scan(/(#{key}){#{max_repeated + 1},}/).empty? }.all?
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
