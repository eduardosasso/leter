class GithubService
  PRIVATE_KEY = Rails.application.credentials.dig(:github_private_key)

  # Your registered app must have a secret set. The secret is used to verify
  # that webhooks are sent by GitHub.
  WEBHOOK_SECRET = Rails.application.credentials.dig(:github_webhook_secret)

  # The GitHub App's identifier (type integer) set when registering an app.
  APP_IDENTIFIER = Rails.application.credentials.dig(:github_app_identifier) 

  # Instantiate an Octokit client authenticated as a GitHub App.
  # GitHub App authentication requires that you construct a
  # JWT (https://jwt.io/introduction/) signed with the app's private key,
  # so GitHub can be sure that it came from the app an not altererd by
  # a malicious third party.
  def authenticate_app
    payload = {
      # The time that this JWT was issued, _i.e._ now.
      iat: Time.now.to_i,

      # JWT expiration time (10 minute maximum)
      exp: Time.now.to_i + (10 * 60),

      # Your GitHub App's identifier number
      iss: APP_IDENTIFIER
    }

    # Cryptographically sign the JWT.
    jwt = JWT.encode(payload, PRIVATE_KEY, 'RS256')

    # Create the Octokit client, using the JWT as the auth token.
    Octokit::Client.new(bearer_token: jwt)
  end

  # Instantiate an Octokit client, authenticated as an installation of a
  # GitHub App, to run API operations.
  def authenticate_installation(id)
    installation_token = authenticate_app.app_client.create_app_installation_access_token(id)[:token]

    Octokit::Client.new(bearer_token: installation_token)
  end
end
