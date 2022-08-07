# frozen_string_literal: true

module Dpop
  # Encrypts and decrypts messages
  class Encryptor
    extend Forwardable

    SECRET = "dpop encrypted message"
    SIGN_SECRET = "signed dpop encrypted message"
    CIPHER = "aes-256-gcm"

    def_delegators :@message_encryptor, :encrypt_and_sign, :decrypt_and_verify

    def initialize(secret)
      @message_encryptor = build_message_encryptor(secret)
    end

    private

    def build_message_encryptor(secret)
      key_generator = ActiveSupport::CachingKeyGenerator.new(
        ActiveSupport::KeyGenerator.new(
          secret,
          iterations: 1000,
          hash_digest_class: OpenSSL::Digest::SHA256
        )
      )
      secret        = key_generator.generate_key(SECRET)[0, 32]
      sign_secret   = key_generator.generate_key(SIGN_SECRET)
      ActiveSupport::MessageEncryptor.new(secret, sign_secret, serializer: JSON, cipher: CIPHER)
    end
  end
end
