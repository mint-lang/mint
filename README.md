<p align="center">
  <img src="documentation/Brand/logo.svg" style="width:250px;"/>
</p>

<h4 align="center">A refreshing programming language for the front-end web.</h4>

<div align="center">
  
  [![CI](https://github.com/mint-lang/mint/actions/workflows/ci.yml/badge.svg)](https://github.com/mint-lang/mint/actions/workflows/ci.yml)
  [![Discord](https://img.shields.io/discord/698214718241767445)](https://discord.gg/NXFUJs2)
  ![Backers on Open Collective](https://opencollective.com/mint/backers/badge.svg)
  ![Sponsors on Open Collective](https://opencollective.com/mint/sponsors/badge.svg)
  
</div>

<div align="center">

  [Install](https://mint-lang.com/install) •
  [Reference](https://mint-lang.com/reference/) •
  [API Docs](https://mint-lang.com/api) •
  [Project Status](#-project-status) •
  [Community](#-community) •
  [Contributing](#-contributing)
  
</div>

```mint
component Counter {
  state counter = 0

  fun increment { next { counter: counter + 1 } }
  fun decrement { next { counter: counter - 1 } }

  fun render {
    <div>
      <button onClick={decrement}>"Decrement"</button>
      <span>counter</span>
      <button onClick={increment}>"Increment"</button>
    </div>
  }
}
```

## 📔&nbsp; Project Status

The project is in development, converging on 1.0. The syntax and and standard library are mostly stable. 
At this point we are polishing the language and refactoring for more stability.

Here are some bigger projects built and maintained by us that showcases the language:

- [Mint Website](https://github.com/mint-lang/mint-website) - The website for the language. It has static content (documentation, blogs) and application like content (sandboxes).
- [Mint Realworld](https://github.com/mint-lang/mint-realworld) - The frontend implementation of the Realworld app.
- [Mint UI](https://github.com/mint-lang/mint-ui) - A UI library written in Mint.
- [Mint UI Website](https://github.com/mint-lang/mint-ui) - The website for Mint UI.
- _Your Project_ - let us know if you writter something amazing with Mint and would like to showcase here!

## 👥&nbsp; Community

Questions or suggestions? Ask on [Discord](https://discord.gg/KvKr5UZKhY). Also, visit 
[Awesome Mint](https://github.com/egajda/awesome-mint), to see more guides, tutorials
and examples.

## 👷&nbsp; Contributing

Read the general [Contributing guide](https://github.com/mint-lang/mint/blob/master/CONTRIBUTING.md).

### Ways you can contribute

- **use the language** - this is the most helpful thing at this stage because we can discover bugs and missing features this way
- **documentation and website** - the documentation always needs some work, if you discover that something is not documented or can be improved you can create a PR for it in the [website repository](https://github.com/mint-lang/mint-website)
- **code review** - the compiler can always use a thorough code review, also code reviews for PRs are welcome
- **standard library** - the standard library can always use some contributions:
  - create modules for not yet implemented Web APIs (or a separate package)
  - a lot of modules like `String`, `Dom`, etc... are missing some features, you can add new functions here (with tests)
- **write a package** - if you have a feature you use and can be moved into a package it can be good for other developers
- **marketing** - write blog posts and such to help others become aware of the language
- **compiler** - there are a few issues that could be fixed and features that can be implemented in the compiler

### ℹ️&nbsp; Questions, Proposals?

Let's discuss in the [Github Discussions](https://github.com/mint-lang/mint/discussions), otherwise please create at [new issue](https://github.com/mint-lang/mint/issues/new)
