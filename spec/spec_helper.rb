# frozen_string_literal: true

require File.join("bundler", "setup")
require "rspec"
require "openssl"
require "jwt"
require "dpop"

RSpec.configure do |config|
  def initialize_gem
    Dpop.configure do |dpop_config|
      dpop_config.encryption_key = "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  initialize_gem

  config.around :each do |example|
    initialize_gem
    example.run
  ensure
    initialize_gem
  end
end
