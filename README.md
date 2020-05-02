# ![Mint](src/assets/mint-logo.svg)

A refreshing programming language for the front-end web, aiming to solve the most common issues of **Single Page Applications (SPAs)** at a language level:

- Reusable components
- Styling
- Routing
- Global and local state handling
- Synchronous and asynchronous computations that might fail

While focusing on:

- Developer happiness
- Fast compilation
- Readability

## Project Status

The project is in development, we are still tweaking the language and standard library.

There are two bigger applications which can be used as examples / learning material:

- the Mint implementation of [realworld.io](https://github.com/gothinkster/realworld) (~3300 LOC) - [DEMO](https://mint-realworld.netlify.com) [SOURCE](https://github.com/mint-lang/mint-realworld)
- the old Mint website (~3100 LOC) [SOURCE](https://github.com/mint-lang/mint-website)

It would be great if you could take part in this short [survey](https://cybergusztav.typeform.com/to/J5mBcK) to provide your feedback about Mint.

## Installing

[Follow these instructions](https://www.mint-lang.com/install)

## Documentation

- [Learning Guide](https://www.mint-lang.com/guide)
- [API Docs](https://www.mint-lang.com/api)

## Community

Questions or suggestions? Ask on [Gitter channel](https://gitter.im/mint-lang/Lobby) or on [Spectrum](https://spectrum.chat/mint-lang).

Also, visit [Awesome Mint](https://github.com/egajda/awesome-mint), to see more guides, tutorials and examples.

## Contributing

Read the general [Contributing guide](https://github.com/crystal-lang/crystal/blob/master/CONTRIBUTING.md), and then:

1. Fork it ( <https://github.com/mint-lang/mint/fork> )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

### Ways you can contribute

- **use the language** - this is the most helpful thing at this stage because we can discover bugs and missing features this way
- **documentation and website** - the documentation always needs some work, if you discover that something is not documented or can be improved you can create a PR for it in the [website repository](https://github.com/mint-lang/mint-website-rails)
- **language features** - if you have any idea about a new language feature, create a detailed issue about it with examples and description (why is it needed? what problems does it solve?)
- **code review** - the compiler can use a thorough code review, also code reviews for PRs are welcome
- **standard library** - the standard library is incomplete and needs a lot of work:
  - create modules for not yet implemented Web APIs (or a separate package)
  - `Time` module needs some rethinking and possibly a rewrite
  - a lot of modules like `String`, `Dom`, etc... are missing a lot of features, you can add new functions here (with tests)
- **write a package** - if you have a feature you use and can be moved into a package it can be good for other developers
- **marketing** - write blog posts and such to help others become aware of the language
- **compiler** - there are a few issues that could be fixed and features that can be implemented in the compiler

### Questions, Proposals?

Let's discuss in the [Mint Gitter Lobby](https://gitter.im/mint-lang/Lobby), otherwise please create at [new issue](https://github.com/mint-lang/mint/issues/new)

## FAQ

### Why functions called `fun` instead of `function`?

You can find an explanation in this issue: <https://github.com/mint-lang/mint/issues/55#issuecomment-404886342>

### Why is the language called Mint?

You can find an explanation in this issue: <https://github.com/mint-lang/mint/issues/53#issuecomment-404717310>

### What makes Mint unique?

You can find an explanation in this issue: <https://github.com/mint-lang/mint/issues/70#issuecomment-412324721>

## Contributors

This project exists thanks to all the people who contribute.
<a href="https://github.com/mint-lang/mint/graphs/contributors"><img src="https://opencollective.com/mint/contributors.svg?width=890&button=false" /></a>

## Backers

Thank you to all our backers! 🙏 [[Become a backer](https://opencollective.com/mint#backer)]

<a href="https://opencollective.com/mint#backers" target="_blank"><img src="https://opencollective.com/mint/backers.svg?width=890"></a>

## Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website. [[Become a sponsor](https://opencollective.com/mint#sponsor)]

<a href="https://opencollective.com/mint/sponsor/0/website" target="_blank"><img src="https://opencollective.com/mint/sponsor/0/avatar.svg"></a>
<a href="https://opencollective.com/mint/sponsor/1/website" target="_blank"><img src="https://opencollective.com/mint/sponsor/1/avatar.svg"></a>
<a href="https://opencollective.com/mint/sponsor/2/website" target="_blank"><img src="https://opencollective.com/mint/sponsor/2/avatar.svg"></a>
<a href="https://opencollective.com/mint/sponsor/3/website" target="_blank"><img src="https://opencollective.com/mint/sponsor/3/avatar.svg"></a>
<a href="https://opencollective.com/mint/sponsor/4/website" target="_blank"><img src="https://opencollective.com/mint/sponsor/4/avatar.svg"></a>
<a href="https://opencollective.com/mint/sponsor/5/website" target="_blank"><img src="https://opencollective.com/mint/sponsor/5/avatar.svg"></a>
<a href="https://opencollective.com/mint/sponsor/6/website" target="_blank"><img src="https://opencollective.com/mint/sponsor/6/avatar.svg"></a>
<a href="https://opencollective.com/mint/sponsor/7/website" target="_blank"><img src="https://opencollective.com/mint/sponsor/7/avatar.svg"></a>
<a href="https://opencollective.com/mint/sponsor/8/website" target="_blank"><img src="https://opencollective.com/mint/sponsor/8/avatar.svg"></a>
<a href="https://opencollective.com/mint/sponsor/9/website" target="_blank"><img src="https://opencollective.com/mint/sponsor/9/avatar.svg"></a>

## License

[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fmint-lang%2Fmint.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fmint-lang%2Fmint?ref=badge_large)

---

[![Build Status](https://travis-ci.org/mint-lang/mint.svg?branch=master)](https://travis-ci.org/mint-lang/mint)
[![Gitter chat](https://badges.gitter.im/gitterHQ/gitter.svg)](https://gitter.im/mint-lang/Lobby)
[![Discord](https://img.shields.io/discord/698214718241767445)](https://discord.gg/NXFUJs2)
[![Join the community on Spectrum](https://withspectrum.github.io/badge/badge.svg)](https://spectrum.chat/mint-lang)
[![Backers on Open Collective](https://opencollective.com/mint/backers/badge.svg)](#backers)
[![Sponsors on Open Collective](https://opencollective.com/mint/sponsors/badge.svg)](#sponsors)
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fmint-lang%2Fmint.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Fmint-lang%2Fmint?ref=badge_shield)
