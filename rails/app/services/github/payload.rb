module Github
  class Payload
    def initialize(data)
      @data = data
    end

    def installation_id
      @data.dig('installation', 'id')
    end

    def username
      @data.dig('installation', 'account', 'login')
    end

    def repository_name
      @data.dig('repository', 'full_name')
    end

    def commit_message
      commits['message']
    end

    def files_updated
      commits['added'] | commits['modified']
    end

    def files_deleted
      commits['removed']
    end

    def original
      @data
    end

    private

    def commits
      @commits ||= @data['head_commit']
    end

  end
end
