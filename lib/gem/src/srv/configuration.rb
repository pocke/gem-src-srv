module Gem
  module Src
    module Srv
      module Configuration
        def self.env(key)
          ENV["GEM_SRC_SRV_#{key}"]
        end

        PORT = env('PORT')&.to_i || 64322
        CONCURRENCY = env('CONCURRENCY')&.to_i || Etc.nprocessors
      end
    end
  end
end
