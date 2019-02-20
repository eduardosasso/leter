module Github
  class Auth
    PRIVATE_KEY = Rails.application.credentials.dig(:github_private_key)
    PRIVATE_KEY_RSA = OpenSSL::PKey::RSA.new(PRIVATE_KEY)

    # that webhooks are sent by GitHub.
    WEBHOOK_SECRET = Rails.application.credentials.dig(:github_webhook_secret)

    # The GitHub App's identifier (type integer) set when registering an app.
    APP_IDENTIFIER = Rails.application.credentials.dig(:github_app_identifier)

    # instantiate an Octokit client, authenticated as an installation of a
    # gitHub App, to run API operations.
    def client(app_install_id)
      install_token = auth_app.create_app_installation_access_token(
        app_install_id,
        accept: 'application/vnd.github.machine-man-preview+json'
      )[:token]

      Octokit::Client.new(bearer_token: install_token)
    end

    private

    # instantiate an Octokit client authenticated as a GitHub App.
    # gitHub App authentication requires that you construct a
    # JWT (https://jwt.io/introduction/) signed with the app's private key,
    # so GitHub can be sure that it came from the app an not altererd by
    # a malicious third party.
    def auth_app
      payload = {
        # The time that this JWT was issued, _i.e._ now.
        iat: Time.now.to_i,

        # JWT expiration time (10 minute maximum)
        exp: Time.now.to_i + (10 * 60),

        # Your GitHub App's identifier number
        iss: APP_IDENTIFIER
      }

      # Cryptographically sign the JWT.
      jwt = JWT.encode(payload, PRIVATE_KEY_RSA, 'RS256')

      # Create the Octokit client, using the JWT as the auth token.
      Octokit::Client.new(bearer_token: jwt)
    end
  end
end

