# Contributing to Mint

So you've decided to contribute to Mint. Excellent!

## Using the issue tracker

The [issue tracker](https://github.com/mint-lang/mint/issues) is the heart of Mint's work. Use it for bugs, questions, proposals and feature requests.

Please always **open a new issue before sending a pull request** if you want to add a new feature to Mint, unless it is a minor fix, and wait until someone from the core team approves it before you actually start working on it. Otherwise, you risk having the pull request rejected, and the effort implementing it goes to waste. And if you start working on an implementation for an issue, please **let everyone know in the comments** so someone else does not start working on the same thing.

Regardless of the kind of issue, please make sure to look for similar existing issues before posting; otherwise, your issue may be flagged as `duplicated` and closed in favour of the original one. Also, once you open a new issue, please make sure to honour the items listed in the issue template.

If you open a question, remember to close the issue once you are satisfied with the answer and you think
there's no more room for discussion. We'll anyway close the issue after some days.

If something is missing from the language it might be that it's not yet implemented or that it was purposely left out. If in doubt, just ask.

The best place to start an open discussion about potential changes is the [discussions](https://github.com/mint-lang/mint/discussions).

## Contributing Workflow

Read this guide then:

- Fork it (<https://github.com/mint-lang/mint/fork>)
- Create your feature branch (`git checkout -b my-new-feature`)
- Commit your changes (`git commit -am 'Add some feature'`)
- Push to the branch (`git push origin my-new-feature`)
- Create a new [Pull Request](https://github.com/mint-lang/mint/pulls)

## Development

### Installing Crystal

We need to install [Crystal](https://crystal-lang.org/) programming language
first. Before installing it, we should install its dependencies.

### Installing Mint dependencies

Once you have Crystal installed install the dependencies needed for building Mint:

```
$ shards install
```

### Building Mint

We use Makefile build automation. Before running this command, create a
`.bin` directory under your home directory.

```
$ mkdir ~/.bin
$ make development
```

After finished, Mint installed as `mint-dev`. Don't forget to add `~/.bin`
directory to your PATH environment variable. We may use `~/.profile`.

```
$ echo 'export PATH=$PATH:$HOME/.bin' >> ~/.profile
$ source ~/.profile
$ which mint-dev
```
