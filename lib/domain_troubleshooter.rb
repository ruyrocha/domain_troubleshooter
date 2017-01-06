require "domain_troubleshooter/version"
require "public_suffix"
require "whois"
require "whois-parser"

module Domain
  class Troubleshooter
    attr_reader :name

    def initialize(name)
      @name = name
    end

    # Public: Checks if domain name is valid.
    #
    # name - String domain name.
    #
    # Returns Boolean.
    def valid?
      ::PublicSuffix.valid?(name)
    end

    # Public: Checks if domain name is registered.
    #
    # Returns Boolean.
    def expired?
      record = whois.parser

      record.expires_on < Time.now
    end

    # Public: Checks if domain name is resolvable.
    #
    # Returns Boolean.
    def resolvable?
      record = resolver.getresource(name, Resolv::DNS::Resource::IN::A)

      record && !record.address.to_s.empty?
    rescue Resolv::ResolvError
      false
    end

    private

    # Private: Sets `whois`.
    #
    # Returns Whois::Client.
    def whois
      @whois ||= ::Whois.lookup(name)
    end

    # Private: Sets `resolver`.
    #
    # Returns Resolv::DNS.
    def resolver
      nameservers = %w(8.8.8.8 8.8.4.4 208.67.222.222 208.67.220.220)

      @resolver ||= ::Resolv::DNS.new(nameserver: nameservers)
    end
  end
end
