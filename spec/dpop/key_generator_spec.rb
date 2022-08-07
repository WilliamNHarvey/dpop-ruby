# frozen_string_literal: true

RSpec.describe Dpop::KeyGenerator do
  describe "generate" do
    it "creates a consumable string" do
      res = described_class.generate
      expect(OpenSSL::PKey::RSA.new(res)).to be_an_instance_of(OpenSSL::PKey::RSA)
    end
  end
end
