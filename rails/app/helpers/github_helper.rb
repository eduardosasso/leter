module GithubHelper
  def payload_raw
    @payload_raw ||= proc do
      request.body.rewind
      request.body.read
    end.call
  end

  def payload
    @payload ||= JSON.parse(payload_raw)
  end

  # check X-Hub-Signature to confirm that this webhook was generated by
  # gitHub, and not a malicious third party.
  #
  # gitHub uses the WEBHOOK_SECRET, registered to the GitHub App, to
  # create the hash signature sent in the `X-HUB-Signature` header of each
  # webhook. This code computes the expected hash signature and compares it to
  # the signature sent in the `X-HUB-Signature` header. If they don't match,
  # this request is an attack, and you should reject it. GitHub uses the HMAC
  # hexdigest to compute the signature. The `X-HUB-Signature` looks something
  # like this: "sha1=123456".
  # See https://developer.github.com/webhooks/securing/ for details.
  def verify_webhook_signature
    their_signature_header = request.headers['X-Hub-Signature'] || 'sha1='

    method, their_digest = their_signature_header.split('=')
    our_digest = OpenSSL::HMAC.hexdigest(method, Github::Auth::WEBHOOK_SECRET.to_s, payload_raw)

    head :unauthorized unless their_digest == our_digest
  end
end
