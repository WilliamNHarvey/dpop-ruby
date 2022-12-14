# frozen_string_literal: true

module Dpop
  # Manages browser cookies
  class CookieJar
    # Error for when cookie is not decipherable
    class InvalidCookieError < StandardError
      def initialize(cookie_name, cookie_value)
        super("invalid value for #{cookie_name}: #{cookie_value}")
      end
    end

    def initialize(encryptor, request_cookies)
      @encryptor       = encryptor
      @request_cookies = request_cookies
    end

    def raw(cookie_name)
      @request_cookies[cookie_name]
    end

    def [](cookie_name)
      try_decrypt(cookie_name)
    end

    def []=(cookie_name, value)
      encrypted_value = @encryptor.encrypt_and_sign(value)
      @request_cookies[cookie_name] = encrypted_value
    end

    def key?(cookie_name)
      @request_cookies.key?(cookie_name)
    end

    private

    def try_decrypt(cookie_name)
      value = @request_cookies[cookie_name]
      return nil if value.blank?

      @encryptor.decrypt_and_verify(value)
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      raise InvalidCookieError.new(cookie_name, value)
    end
  end
end
