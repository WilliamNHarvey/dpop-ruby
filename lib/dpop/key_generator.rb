# frozen_string_literal: true

module Dpop
  module KeyGenerator
    class UnsupportedAlgorithmError < StandardError
      def initialize(alg)
        super("Unsupported algorithm received: #{alg}")
      end
    end

    def generate(alg = :rsa)
      # TODO support more algs
      raise UnsupportedAlgorithmError.new(alg) if alg != :rsa

      OpenSSL::PKey::RSA.generate(Dpop.config.generated_key_size).to_pem
    end

    module_function :generate
  end
end
