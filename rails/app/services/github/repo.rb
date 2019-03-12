module Github
  class Repo
    attr_reader :github, :repo, :ref

    def initialize(conn, payload)
      @github = conn
      @repo = payload.repository_name
      @ref = 'heads/master' #TODO, other branches gh-pages?
    end

    def sha_latest_commit
      github.ref(repo, ref).object.sha
    end

    def sha_base_tree
      github.commit(repo, sha_latest_commit).commit.tree.sha
    end

    def files
      github.tree(repo, sha_base_tree, recursive: true)
    end

    def markdown_files
      md = files[:tree].select { |f| Markdown.is?(f[:path]) }

      md.map { |f| f[:path] }
    end

    def name
      @repo
    end
  end
end
