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
      #TODO improve to only get message from commits with changed MD files
      commits['message'].join(', ')
    end

    def files_updated
      commits['updated']
    end

    def files_deleted
      commits['removed']
    end

    def original
      @data
    end

    private

    def commits
      commits = {
        'updated' => [],
        'removed' => [],
        'message' => []
      }

      @data['commits'].each do |c|
        commits['updated'] += (c['added'] | c['modified'])
        commits['removed'] += c['removed']
        commits['message'] << c['message']
      end

      commits
    end

  end
end
