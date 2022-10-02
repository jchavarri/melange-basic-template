# dune-mel-rescript-benchmarks

A small project to benchmark build times between different setups:
- Using ReScript
- Using Melange + Dune, without `library` stanza integration
- Using Melange + Dune, with `library` stanza integration

Built on top of [Melange simple project template](https://github.com/melange-re/melange).

## Quick Start

```shell
make init # installs opam switch + opam deps + npm deps
```

Run benchmarks:
```shell
make start-benchmark
```
