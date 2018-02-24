require 'net/http'
require 'uri'

Gem.post_install do |installer|
  uri = URI.parse('http://localhost:20080/gem_install')
  req = Net::HTTP::Post.new(uri)
  req.body = Marshal.dump(installer.spec)
  Net::HTTP.new(uri.host, uri.port).start {|http| http.request(req) }
rescue # FIXME
end
