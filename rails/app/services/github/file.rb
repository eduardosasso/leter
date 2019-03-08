# conn = Github::Auth.new.client(645366)
# Github::File.new(conn).content("eduardosasso/eduardosasso.github.io", "index.md")
module Github
  class File
    def initialize(conn, repo)
      @conn = conn
      @repo = repo
    end

    def content(filename)
      data = content_ref(filename)

      Base64.decode64(data['content'])
    rescue Octokit::NotFound
      raise FileNotFoundError.new("#{filename} not found")
    end

    def delete(filename, message)
      sha = content_ref(filename)[:sha]

      @conn.delete_contents(
        @repo,
        filename,
        message,
        sha
      )
    end

    def content_ref(filename)
      @conn.contents(@repo, path: filename)
    end
  end
end
