module Github
  class Commit
    attr_reader :github, :repo, :ref, :commit_message

    def initialize(conn, payload)
      @github = conn
      @repo = payload.repository_name
      @ref = 'heads/master' #TODO, other branches gh-pages?
      @commit_message = '〰️ ' + payload.commit_message
    end

    #http://mattgreensmith.net/2013/08/08/commit-directly-to-github-via-api-with-octokit/
    def push(items = [])
      #TODO, delete
      #TODO, create dir
      #TODO understand if the latest commit is enough
      sha_latest_commit = github.ref(repo, ref).object.sha
      sha_base_tree = github.commit(repo, sha_latest_commit).commit.tree.sha

      changes = items.map do |item|
        content = Base64.encode64(item.html)

        blob_sha = github.create_blob(repo, content, :base64)

        {
          path: item.filename,
          mode: '100644',
          type: 'blob',
          sha: blob_sha
        }
      end

      # blob_sha = github.create_blob(repo, Base64.encode64('new commit updated'), "base64")

      # sha_new_tree = github.create_tree(repo,
      #                                   [ { :path => 'index.html',
      #                                  :mode => "100644",
      #                                  :type => "blob",
      #                                  :sha => blob_sha }] ,
      #                              {:base_tree => sha_base_tree }).sha

      sha_new_tree = github.create_tree(repo, changes, base_tree: sha_base_tree).sha

      #TODO should mimick commit msg from last commit
      sha_new_commit = github.create_commit(
        repo,
        commit_message,
        sha_new_tree,
        sha_latest_commit
      ).sha

      github.update_ref(repo, ref, sha_new_commit)
    end
  end
end
