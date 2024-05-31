# frozen_string_literal: true

require "active_support/json"
require "active_support/key_generator"
require "active_support/message_encryptor"
require "jwt"
require "openssl"
require "securerandom"

# DPoP top level methods
module Dpop
  class Error < StandardError; end

  autoload :Configuration,  "dpop/configuration"
  autoload :Controller,     "dpop/controller"
  autoload :CookieJar,      "dpop/cookie_jar"
  autoload :Encryptor,      "dpop/encryptor"
  autoload :KeyGenerator,   "dpop/key_generator"
  autoload :ProofGenerator, "dpop/proof_generator"
  autoload :Version,        "dpop/version"

  class << self
    # Configure Dpop application-wide settings.
    #
    # Yields a configuration object that can be used to override default settings.
    def configure
      yield(configuration) if block_given?
    end

    # Returns the client's Configuration object, or creates one if not yet created.
    def configuration
      @configuration ||= Dpop::Configuration.new
    end

    alias config configuration

    def get_proof_with_key(dpop_key, **args)
      generator = Dpop::ProofGenerator.new(dpop_key, "RS256")
      generator.create_dpop_proof(**args)
    end

    def generate_key_pair(alg = :rsa)
      Dpop::KeyGenerator.generate(alg)
    end

    def load_integration
      require "dpop/railtie" if defined?(Rails::Railtie)
    end
  end
end

Dpop.load_integration
