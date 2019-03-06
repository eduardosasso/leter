module Github
  class App
    attr_reader :payload

    def initialize(payload)
      @payload =  Github::Payload.new(payload)
    end

    def install
      github_user = Github::User.new(conn, payload.username)

      ::User.create!(
        name: github_user.name,
        email: github_user.email,
        password: SecureRandom.alphanumeric(10),
        github_app: payload.original,
        github_app_install_id: payload.installation_id
      )

      #TODO - should loop on repos and add to user_repos?
      #TODO, premium - one repo free, many repos?
      #TODO save leter.yml with config params 
    end

    def uninstall
      #TODO handle this
    end

    def repo_add
      #TODO, for leter-test
      #save in user_repos?
    end

    def repo_remove
      #TODO, test
    end

    def build
      repo = payload.repository_name
      file = Github::File.new(conn, repo)      
      response = {push: nil, delete: nil}

      items = payload.files_updated.map do |f|
        content = file.content(f)

        Item.new.tap do |i|
          i.filename = Slug.new(f).to_s
          i.html = PageBuilder.new(content, config).html 
        end
      end

      response[:push] = Github::Commit.new(conn, payload).push(items)

      response[:delete] = payload.files_deleted.map do |f|
        name = Slug.new(f).to_s

        file.delete(name, "original deleted #{f}")
      end

      response
    end

    #TODO serverless build?
    def build_async
      Github::BuildJob.perform(payload.original)
    end

    private
    
    def config
      AccountConfig.default
      # TODO load leter.yml from master
    end

    def conn
      Github::Auth.new.client(payload.installation_id)
    end
  end
end
