module Gem::Src::Srv
  class Worker
    def self.start(queue)
      Configuration::CONCURRENCY.times do
        self.new(queue).start
      end
    end

    def initialize(queue)
      @queue = queue
    end

    def start
      Thread.new do
        loop do
          spec = @queue.pop
          fetcher = Fetcher.new(spec)
          fetcher.fetch
        end
      end
    end
  end
end
