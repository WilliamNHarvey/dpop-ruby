# frozen_string_literal: true

module Dpop
  class Configuration
    attr_accessor :cookie_name
    attr_accessor :encryption_key
    attr_accessor :generated_key_size
    attr_accessor :logger
    attr_accessor :key_alg

    DEFAULT_COOKIE_NAME = "_proof_keys"
    DEFAULT_ENCRYPTION_KEY = ENV["DPOP_ENCRYPTION_KEY"] || ""
    DEFAULT_GENERATED_KEY_SIZE = 1024
    DEFAULT_KEY_ALG = :rsa

    def initialize
      self.cookie_name = DEFAULT_COOKIE_NAME
      self.logger = Logger.new($stdout)
      self.encryption_key = DEFAULT_ENCRYPTION_KEY
      self.generated_key_size = DEFAULT_GENERATED_KEY_SIZE
      self.key_alg = DEFAULT_KEY_ALG
    end

    def encryptor
      @encryptor ||= Dpop::Encryptor.new(encryption_key)
    end

    private
  end
end
