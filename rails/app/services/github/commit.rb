module Github
  class Commit
    attr_reader :github, :repo, :ref, :commit_message

    def initialize(conn, payload)
      @github = conn
      @repo = Github::Repo.new(conn, payload)
      @ref = 'heads/master' #TODO, other branches gh-pages?
      @commit_message = '〰️ ' + payload.commit_message
    end

    #http://mattgreensmith.net/2013/08/08/commit-directly-to-github-via-api-with-octokit/
    def push(items = [])
      changes = items.map do |item|
        content = Base64.encode64(item.data)

        blob_sha = github.create_blob(repo_name, content, :base64)

        {
          path: item.filename,
          mode: '100644',
          type: 'blob',
          sha: blob_sha
        }
      end

      commit(changes) if changes.any?
    end

    private

    def commit(changes = [])
      sha_new_tree = github.create_tree(repo_name, changes, base_tree: sha_base_tree).sha

      sha_new_commit = github.create_commit(
        repo_name,
        commit_message,
        sha_new_tree,
        sha_latest_commit
      ).sha

      github.update_ref(repo_name, ref, sha_new_commit)
    end

    def sha_latest_commit
      repo.sha_latest_commit
    end

    def sha_base_tree
      repo.sha_base_tree
    end

    def repo_name
      repo.name
    end
  end
end
