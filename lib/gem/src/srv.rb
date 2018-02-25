require 'webrick'
require 'net/http'
require 'open-uri'
require 'json'

module Gem
  module Src
    module Srv
      def self.start
        queue = Queue.new
        Worker.start(queue)
        Server.start(queue)
      end
    end
  end
end

require_relative "srv/version"
require_relative "srv/irregular_repositories"
require_relative "srv/fetcher"
require_relative "srv/server"
require_relative "srv/worker"
