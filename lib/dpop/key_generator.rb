# frozen_string_literal: true

module Dpop
  # Generates private keys
  module KeyGenerator
    # Error for receiving an unrecognized algorithm
    class UnsupportedAlgorithmError < StandardError
      def initialize(alg)
        super("Unsupported algorithm received: #{alg}")
      end
    end

    def generate(alg = :rsa)
      # TODO: support more algs
      raise UnsupportedAlgorithmError, alg if alg != :rsa

      OpenSSL::PKey::RSA.generate(Dpop.config.generated_key_size).to_pem
    end

    module_function :generate
  end
end
