require 'net/http'
require 'uri'
require 'retryable'

Gem.post_install do |installer|
  next if installer.spec.name == 'gem-src-srv'

  spawn('gem-src-srv', [:out, :err] => '/dev/null')

  Retryable.retryable(tries: 3, sleep: 0.1, on: Errno::ECONNREFUSED) do
    uri = URI.parse('http://localhost:20080/gem_install')
    req = Net::HTTP::Post.new(uri)
    req.body = Marshal.dump(installer.spec)
    Net::HTTP.new(uri.host, uri.port).start {|http| http.request(req) }
  end
end
