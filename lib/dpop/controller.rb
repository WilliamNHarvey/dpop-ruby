# frozen_string_literal: true

module Dpop
  module Controller
    extend ActiveSupport::Concern

    class MissingDpopCookie < StandardError
      def initialize(cookie_name)
        super("No DPoP cookie found with name `#{cookie_name}`. Try running `ensure_dpop!` before using this concern.")
      end
    end

    class_methods do
      def ensure_dpop!
        return if cookie_jar[Dpop.config.cookie_name]

        cookie_jar[Dpop.config.cookie_name]=Dpop::KeyGenerator.generate
      end

      def get_proof(**args)
        dpop_key = cookie_jar[Dpop.config.cookie_name]
        raise MissingDpopCookie.new(Dpop.config.cookie_name) unless dpop

        generator = Dpop::ProofGenerator.new(dpop_key, "RS256")
        generator.create_dpop_proof(args)
      end

      private

      def cookie_jar
        Dpop::CookieJar.new(Dpop.config.encryptor, request.cookies)
      end
    end
  end
end
