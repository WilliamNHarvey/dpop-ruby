# frozen_string_literal: true

RSpec.describe Dpop::ProofGenerator do
  before do
    @dpop_key = "-----BEGIN RSA PRIVATE KEY-----\nMIICXAIBAAKB
gQCvOA3ggltUxHHrhb2YbjIx4391BSbR9N5mAjTq8XRmyWlv6JXQ\nWqD2emxta+wc/i6oFhQH7NFYVgZ+
WtlBDGY8L1yzgDDPXmtExJe8gBeSIKwclb+g\nOD4bURiIJuc70JwdOU9q+ssFPXP1vAKbGRfHE5EKx33A
Bfz5bdN84358PQIDAQAB\nAoGATUcDl8jmTvR06dMKU3gGW0pipFGpVWAR1huTCyuCkvKxtdF2gXX3F73W
pEu8\nzuyr1yYln3kquzL1mjSnLLEzRQyx3G/UXvBahkDPzgSe3PKvB28Mj3dAqTiUXXYu\nfnKcaGGY/i
TF0psom1jQc7EkQKrWznKrmNU7lDTOlpGHRwECQQDjjGkws5dfU4xU\nR8Rd/llFTRBPFVFFnvUD+6BmUR
Vfydww+qXNHtXRvFOh55csv36GbEmlpvmdX4bT\n5aLQO4zFAkEAxSChTkcGf2YHIR0I4v5+60dK7dkoJ/
l8YR2PcbCJxR0fHEzWNBXV\n/iWK/ZaMBaQC+sLkVYuRDBwfxKFMXRyZGQJAYy3vJ2gPwV/0GUQSpflXxa
n6Qs4C\n13qaRrslRZNv4olkbQDCxa37+mfAeCAuNzXcGxEV5Jrrz5k0diVwGpzqFQJBAJVQ\nbv5kzCYp
uRK69GVEEgzS1o2spD8LOcwx4NpjtydINK1yAfo34/x6oXoN04feQKeC\nggPOEJMUpneBGd+ZbtkCQEDs
QLGTlo2fXEvX4CXrQN3bE0pf3LM/pkloXC4IyYID\nBXVSoEHVPDv/E/I0UALk2QK9y+zcBWaY4w6DnMlF
v3M=\n-----END RSA PRIVATE KEY-----\n"

    @generator = described_class.new(@dpop_key, "RS256")
  end

  describe "create_dpop_proof" do
    it "creates a properly formatted proof jwt" do
      jwt = @generator.create_dpop_proof(htu: "https://www.williamnharvey.com", htm: "GET")
      decoded_token = JWT.decode(jwt, nil, false)

      expect(decoded_token[1]["typ"]).to eq("dpop+jwt")
      expect(decoded_token[1]["alg"]).to eq("RS256")
      expect(decoded_token[0]["htu"]).to eq("https://www.williamnharvey.com")
      expect(decoded_token[0]["htm"]).to eq("GET")
    end
  end
end
