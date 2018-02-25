require 'net/http'
require 'uri'
require 'retryable'
require 'json'

require 'gem/src/srv/configuration'


Gem.post_install do |installer|
  next if installer.spec.name == 'gem-src-srv'

  spawn('gem-src-srv', [:out, :err] => '/dev/null')

  Retryable.retryable(tries: 3, sleep: 0.1, on: Errno::ECONNREFUSED) do
    port = Gem::Src::Srv::Configuration::PORT
    uri = URI.parse("http://localhost:#{port}/gem_install")
    req = Net::HTTP::Post.new(uri)
    req.body = JSON.generate({
      name: installer.spec.name,
      homepage: installer.spec.homepage,
    })
    req.content_type = 'Application/json'
    Net::HTTP.new(uri.host, uri.port).start {|http| http.request(req) }
  end
end
