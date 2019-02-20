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
      #TODO, should be single commit
      repo = payload.repository_name
      file = Github::File.new(conn)

      #TODO,
      #rename file from md to html
      #if file not index then create a folder with file name slug minus extension
      #and save the content inside index file so can hit url without .html
      
      items = payload.files_updated.map do |f|
        content = file.content(repo, 'index.md')

        Item.new.tap do |i|
          i.filename = f
          i.html = Markdown.new(content).to_html
          i.status = Item::STATUS[:updated]
        end
      end

      items |= payload.files_deleted.map do |f|
        Item.new.tap do |i|
          i.filename = f
          i.status = Item::STATUS[:deleted]
        end
      end

      Github::Commit.new(conn, payload).push(items)
    end


    #TODO serverless build?
    def build_async
      Github::BuildJob.perform(payload.original)
    end

    private

    def conn
      Github::Auth.new.client(payload.installation_id)
    end
  end
end
