# Contributing Guideline

Read the general [Contributing guide][1], and then:

- Fork it (<https://github.com/mint-lang/mint/fork>)
- Create your feature branch (`git checkout -b my-new-feature`)
- Commit your changes (`git commit -am 'Add some feature'`)
- Push to the branch (`git push origin my-new-feature`)
- Create a new [Pull Request](https://github.com/mint-lang/mint/pulls)

[1]: https://github.com/crystal-lang/crystal/blob/master/CONTRIBUTING.md

## Development

### Installing Crystal

We need to install [Crystal](https://crystal-lang.org/) programming language
first. Before installing it, we should install its dependencies.

##### Ubuntu

```
$ sudo apt update
$ sudo apt install pkg-config ubuntu-dev-tools
```

Then, follow [this instruction][2].

[2]: https://crystal-lang.org/docs/installation/on_debian_and_ubuntu.html

### Installing Mint dependencies

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
