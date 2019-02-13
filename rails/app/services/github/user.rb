module Github
  class User
    def initialize(conn, username)
      @conn = conn
      @username = username
    end

    def email
      data['email']
    end

    def name
      data['name']
    end

    def data
      @data ||= @conn.user(@username)
    end
  end
end
