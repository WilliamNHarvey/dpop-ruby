# frozen_string_literal: true

RSpec.describe Dpop::Encryptor do
  before do
    @encryptor = described_class.new(Dpop.config.encryption_key)
  end

  describe "encrypt_and_sign" do
    it "encrypts without errors" do
      expect { @encryptor.encrypt_and_sign("secret") }.not_to raise_error
    end
  end

  describe "decrypt_and_verify" do
    it "decrypts accurately" do
      expect(@encryptor.decrypt_and_verify("BLQW8G1MYxw=--8PkFY8CdPGinTgwd--MKAzkYmMejz63DLJL5D8cg==")).to eq("secret")
    end
  end
end
