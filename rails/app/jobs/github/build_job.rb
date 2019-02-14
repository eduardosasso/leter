module Github
  class BuildJob < ApplicationJob
    queue_as :default

    def perform(payload)
      Github::App.new(payload).build
    end
  end
end
