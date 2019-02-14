# conn = Github::Auth.new.client(645366).conn
# Github::File.new(conn).content("eduardosasso/eduardosasso.github.io", "index.md")
module Github
  class File
    def initialize(conn)
      @conn = conn
    end

    def content(repo, filename)
      data = @conn.contents(repo, path: filename)

      Base64.decode64(data['content'])
    end
  end
end
