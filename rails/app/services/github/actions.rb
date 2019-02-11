module Github
  class Actions
    def initialize(github_connection)
      @github = github_connection
    end

    #TODO should receive data in specific format with content and name.html
    def update_or_insert_file(content = [])
      # TODO come from config 
      repo = 'eduardosasso/eduardosasso.github.io'
      ref = 'heads/master'

      #http://mattgreensmith.net/2013/08/08/commit-directly-to-github-via-api-with-octokit/
      #TODO understand if the latest commit is enough
      sha_latest_commit = @github.ref(repo, ref).object.sha
      # logger.debug("sha_last_commit " + sha_latest_commit)

      sha_base_tree = @github.commit(repo, sha_latest_commit).commit.tree.sha
      # logger.debug("sha_base_tree" + sha_base_tree)

      blob_sha = @github.create_blob(repo, Base64.encode64('new commit updated'), "base64")
      # blob_sha_new = @github.create_blob(repo, Base64.encode64('x new file updated'), "base64")

      sha_new_tree = @github.create_tree(repo,
                                        [ { :path => 'index.html',
                                       :mode => "100644",
                                       :type => "blob",
                                       :sha => blob_sha }] ,
                                   {:base_tree => sha_base_tree }).sha

      #TODO should mimick commit msg from last commit
      commit_message = "Committed via Octokit! new change"
      sha_new_commit = @github.create_commit(repo, commit_message, sha_new_tree, sha_latest_commit).sha

      updated_ref = @github.update_ref(repo, ref, sha_new_commit)

    end
  end
end
