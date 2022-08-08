# frozen_string_literal: true

module Dpop
  # Controller concern for Rails
  module Controller
    extend ActiveSupport::Concern

    # Error for DPoP cookie not being found
    class MissingDpopCookie < StandardError
      def initialize(cookie_name)
        super("No DPoP cookie found with name `#{cookie_name}`. Try running `ensure_dpop!` before using this concern.")
      end
    end

    included do
      class_attribute :ensure_dpop_on_actions
      self.ensure_dpop_on_actions = false

      # Set up the around_action which ensures the cookie is set on request if the controller has ensure_dpop! set
      before_action :set_dpop_cookie
    end

    class_methods do
      def ensure_dpop!
        self.ensure_dpop_on_actions = true
      end
    end

    def get_proof(**args)
      dpop_key = cookie_jar[Dpop.config.cookie_name]
      raise MissingDpopCookie, Dpop.config.cookie_name unless dpop_key

      generator = Dpop::ProofGenerator.new(dpop_key, "RS256")
      generator.create_dpop_proof(args)
    end

    def set_dpop_cookie
      return unless ensure_dpop_on_actions
      return if cookie_jar.key?(Dpop.config.cookie_name)

      generated = Dpop::KeyGenerator.generate(Dpop.config.key_alg)

      cookie_jar[Dpop.config.cookie_name] = generated
      cookies[Dpop.config.cookie_name] = { value: cookie_jar.raw(Dpop.config.cookie_name), httponly: true }
    end

    private

    def cookie_jar
      Dpop::CookieJar.new(Dpop.config.encryptor, request.cookies)
    end
  end
end
