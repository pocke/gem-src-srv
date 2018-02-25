module Gem::Src::Srv
  class Server
    def self.start(queue)
      self.new(queue).start
    end

    def initialize(queue)
      @queue = queue
    end

    def start
      srv = WEBrick::HTTPServer.new(
        BindAddress: '127.0.0.1',
        Port: 20080,
      )
      srv.mount_proc('/gem_install') do |req, resp|
        if req.request_method != 'POST'
          resp.status = 404
          next
        end

        @queue << Marshal.load(req.body)
      end
      trap('INT') { srv.shutdown }
      srv.start
    end
  end
end
