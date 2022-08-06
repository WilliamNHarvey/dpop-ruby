# frozen_string_literal: true

module Dpop
  module KeyGenerator
    def generate
      OpenSSL::PKey::RSA.generate(Dpop.config.generated_key_size).to_pem
    end

    module_function :generate
  end
end
