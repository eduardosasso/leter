module Github
  class App
    attr_reader :payload
    def initialize(payload)
      @payload =  Github::Payload.new(payload)
    end

    def install
      conn = Github::Auth.new.client(payload.installation_id)
      github_user = conn.user(payload.username)

      ::User.create!(
        name: github_user.name,
        email: github_user.email, 
        password: SecureRandom.alphanumeric(10),
        github_app: payload.original, 
        github_app_install_id: payload.installation_id
      )
    end

    def uninstall
      #TODO handle this
    end

    def build
      #TODO, should be single commit
      payload.files_updated.each do |f|
       #get latest content  
       #generate html
       #return some sort of array with filename + html_content
      end

      payload.files_deleted.map do |f|
        #issue a delete commit
      end

      #push commit to github
    end


    #TODO serverless build?
    def build_async
      Github::BuildJob.perform(payload.original)
    end
  end
end
