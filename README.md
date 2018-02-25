# Gem::Src::Srv

Run `git clone` after `gem install` concurrently. Inspired by [gem-src](https://github.com/amatsuda/gem-src)

## Installation

```bash
$ gem install gem-src-srv
```

## Usage

It clones a git repository after you install a gem with [ghq](https://github.com/motemen/ghq).

```bash
$ gem install rails
$ ghq list | grep rails/rails
github.com/rails/rails
```

Note: If you want to clone repositories with plain `git clone` command, you can send a pull-request!

### Configuration

You can set `GEM_SRC_SRV_PORT` and `GEM_SRC_SRV_CONCURRENCY` environment variables.

See [lib/gem/src/srv/configuration.rb](https://github.com/pocke/gem-src-srv/blob/master/lib/gem/src/srv/configuration.rb).

## Design

gem-src is good, but it clones a repository synchronously. So it makes `gem install` slow.

gem-src-srv clones a repository concurrently. So it does not block `gem install`, it's faster!

### How concurrently?

gem-src-srv works on Client-Server model.

![img_20180225_124045652](https://user-images.githubusercontent.com/4361134/36637896-47fa1daa-1a29-11e8-828a-c37aaa36f6ac.jpg)

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pocke/gem-src-srv.
