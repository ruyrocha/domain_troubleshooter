require 'spec_helper'

describe Domain::Troubleshooter do
  let(:valid_domain)   { "google.com" }
  let(:invalid_domain) { "google.com.abcdefgh11111111111111" }

  it 'has a version number' do
    expect(Domain::Troubleshooter::VERSION).not_to be nil
  end

  describe "#valid?" do
    it "returns true for valid domains" do
      klass = described_class.new(valid_domain)

      expect(klass.valid?).to be_truthy
    end

    it "returns falsey for invalid domains" do
      klass = described_class.new(invalid_domain)

      expect(klass.valid?).to be_falsey
    end
  end

  describe "#resolvable?" do
    context "domain name has address" do
      subject { described_class.new(valid_domain).resolvable? }

      it { is_expected.to be_truthy }
    end

    context "domain name does not have address" do
      subject { described_class.new(invalid_domain).resolvable? }

      before do
        allow(Resolv::DNS).to receive(:getresource).and_raise(
          Resolv::ResolvError, "DNS result has no information for #{invalid_domain}"
        )
      end

      it { is_expected.to be_falsey }
    end
  end

  describe "#expired?" do
    context "expired domains" do
      let(:dummy_record) do
        "tons of data...\n   Expiration Date: 05-dec-2016\n\n ... more data here"
      end

      before do
        allow(Whois).to receive(:lookup).and_return(dummy_record)

        allow(dummy_record).to receive(:parser).and_return(
          double(expires_on: Time.new(2016,12,05,18,00,8, "-05:00"))
        )
      end

      it "checks if a given domain name has expired" do
        klass = described_class.new(valid_domain)

        expect(klass.expired?).to be_truthy
      end
    end
  end
end
