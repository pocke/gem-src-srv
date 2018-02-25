module Gem::Src::Srv
  class Fetcher
    def self.tested_repositories
      @tested_repositories ||= []
    end

    def tested_repositories
      self.class.tested_repositories
    end

    def initialize(spec)
      @spec = spec
    end

    def fetch
      if IRREGULAR_REPOSITORIES.key? spec.name
        return git_clone IRREGULAR_REPOSITORIES[spec.name]
      end

      git_clone(spec.homepage) ||
        git_clone(github_url(spec.homepage)) ||
        git_clone(source_code_uri) ||
        git_clone(homepage_uri) ||
        git_clone(github_url(homepage_uri)) ||
        git_clone(github_organization_uri(spec.name))
    end

    private

    attr_reader :spec

    def git_clone(repository)
      return if repository.nil? || repository.empty?
      return if tested_repositories.include? repository
      tested_repositories << repository
      return if github?(repository) && !github_page_exists?(repository)

      system 'ghq', 'get', repository
    end

    def github?(url)
      URI.parse(url).host == 'github.com'
    end

    def github_page_exists?(url)
      Net::HTTP.new('github.com', 443).tap {|h| h.use_ssl = true }.request_head(url).code != '404'
    end

    def github_url(url)
      if url =~ /\Ahttps?:\/\/([^.]+)\.github\.(?:com|io)\/(.+)/
        if $1 == 'www'
          "https://github.com/#{$2}"
        elsif $1 == 'wiki'
          # https://wiki.github.com/foo/bar => https://github.com/foo/bar
          "https://github.com/#{$2}"
        else
          # https://foo.github.com/bar => https://github.com/foo/bar
          "https://github.com/#{$1}/#{$2}"
        end
      end
    end

    def api
      @api ||= open("https://rubygems.org/api/v1/gems/#{spec.name}.yaml", &:read)
    rescue OpenURI::HTTPError
      ""
    end

    def source_code_uri
      api_uri_for('source_code')
    end

    def homepage_uri
      api_uri_for('homepage')
    end

    def github_organization_uri(name)
      "https://github.com/#{name}/#{name}"
    end

    def api_uri_for(key)
      uri = api[Regexp.new("^#{key}_uri: (.*)$"), 1]
      uri =~ /\A(?:https?|git):\/\// ? uri : nil
    end
  end
end
