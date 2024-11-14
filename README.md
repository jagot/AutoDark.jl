# AutoDark

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://jagot.github.io/AutoDark.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jagot.github.io/AutoDark.jl/dev/)
[![Build Status](https://github.com/jagot/AutoDark.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/jagot/AutoDark.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/jagot/AutoDark.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/jagot/AutoDark.jl)

React to theme switches.
Supported operating systems/desktop environments:
- macOS (using [`dark-notify`](https://github.com/cormacrelf/dark-notify))
- Gnome (using `gsettings`)

![AutoDark.jl demo](./demo.gif)

## Usage
```julia
using AutoDark
auto_dark(f)
```
This returns immediately and spawns an async thread that listens for changes
to the color scheme.
Whenever such a change is detected, it calls `f` with either `:light`, `:dark`
or `:unknown`.
