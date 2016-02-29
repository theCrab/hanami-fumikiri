module Hanami
  module Fumikiri
    include JsonWebToken
    attr_reader :api_key

    def initialize
      # @api_key ||= User.new
    end

    def issue(args={})
      opts= args.opts #=> { user_id: '', exp: Time.in_seconds, iss: 'https/www.paxi.uk/', org_id: 1234, device_id: 12345 }
      sign(opts, { alg: 'RSA256', key: < RSA private key >})
    end

    def compare(args)
      verify()
    end
  end
end
