module Github
  class App
    def initialize(payload)
      @payload = payload
      @install_id = payload.dig('installation', 'id')
      @username = payload.dig('installation', 'account', 'login')
    end

    def install
      conn = Github::Auth.new.client(@install_id)
      github_user = conn.user(@username)

      ::User.create!(
        name: github_user.name,
        email: github_user.email, 
        password: SecureRandom.alphanumeric(10),
        github_app: @payload, 
        github_app_install_id: @install_id
      )
    end

    def uninstall
      #TODO handle this
    end
  end
end
