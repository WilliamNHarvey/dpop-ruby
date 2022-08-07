# frozen_string_literal: true

module Dpop
  class ProofGenerator
    JWT_TYPE = "dpop+jwt"
    RSA = "RSA"

    class MissingKeyError < StandardError
      def initialize
        super("DPoP key blank")
      end
    end

    class InvalidKeyError < StandardError
      def initialize(key)
        super("Unrecognized key format for DPoP key: #{key}")
      end
    end

    def initialize(dpop_key, alg)
      raise MissingKeyError if dpop_key.blank?

      @dpop_key = dpop_key
      @alg = alg
    end

    # Takes the path being called. Returns a signed JWT
    def create_dpop_proof(htu:, htm:, nonce: nil, ath: nil, iat: Time.now.to_i, jti: SecureRandom.uuid, **additional)
      private_key, public_key = keys

      headers = {
        alg: @alg,
        typ: JWT_TYPE,
        jwk: public_key
      }

      payload = {
        htu: htu,
        htm: htm,
        ath: ath,
        iat: iat,
        jti: jti,
        nonce: nonce
      }.merge(additional).compact

      JWT.encode(payload, private_key, @alg, headers)
    end

    private

    # We only support RSA keys in the form of pem strings.
    def keys
      return [@private_key, @public_key] if defined?(@private_key) && defined?(@public_key)

      if @dpop_key.instance_of? String
        @private_key = OpenSSL::PKey::RSA.new(@dpop_key)
        @public_key = {
          kty: RSA,
          n: Base64.urlsafe_encode64(@private_key.n.to_s(2), padding: false),
          e: Base64.urlsafe_encode64(@private_key.e.to_s(2), padding: false)
        }
        [@private_key, @public_key]
      else
        raise InvalidKeyError, @dpop_key
      end
    end
  end
end
