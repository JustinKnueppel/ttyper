# ttyper

`ttyper` is a simple command line typing test written in OCaml. It is inspired by the project of the same name by Max Niederman ([repo](https://github.com/max-niederman/ttyper)). I am a lover of functional programming but completely new to OCaml and am using this as a learning opportunity to build something practical while also learning my [Enthium](https://sunaku.github.io/enthium-keyboard-layout.html) keyboard layout.

## Development

This project is build with Opam and dune on OCaml 5.3.0. It uses the [Minttea](https://github.com/leostera/minttea) TUI library which uses the ELM architecture. Because Minttea and its underlying library Riot seem to be unmaintained and do not compile on OCaml 5.3.0, I have forked both and gotten them compiling.

## TODO

- Use a zipper on the word list to be able to easily go forward/backwards while checking accuracy
- Investigate why `Command.Quit` doesn't always quit. Unsure if it's an issue with Riot, Minttea, or my forks of one of them.
- End test when you reach the end of the input
- Give accurcy score
- Randomly generate tests from word set
- Report seed used for test generation for reproducible tests
- Allow exporting stats
- Track character accurcy
- Track word accurcy
- Much, much more
