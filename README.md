# ocaml-merlin

_Use [ocamlmerlin] to autocomplete, lint and navigate your OCaml code in Atom._


## Features

* Context-sensitive autocompletion and linting
* Show the type of expressions under the cursor
* Find all occurrences of a variable
* Jump to (type) declarations and back
* Shrink and grow selections in a smart way
* Rename all occurrences of a variable in a file

## Usage

Linting is performed on save by [linter]. Autocompletion is performed on the fly by [autocomplete-plus].

No default keybindings are provided, except those compatible with the `symbols-view` package. Additional keybindings can be set in your keymap.

| Command                                | Description                            | Keybinding (Linux, Windows) | Keybinding (OS X)       |
| -------------------------------------- | -------------------------------------- | --------------------------- | ----------------------- |
| `ocaml-merlin:show-type`               | Show type of expression under cursor   |                             |                         |
| `ocaml-merlin:shrink-type`             | Shrink the expression                  |                             |                         |
| `ocaml-merlin:expand-type`             | Expand the expression                  |                             |                         |
| `ocaml-merlin:next-occurrence`         | Find next occurrence of expression     |                             |                         |
| `ocaml-merlin:previous-occurrence`     | Find previous occurrence of expression |                             |                         |
| `ocaml-merlin:go-to-declaration`       | Go to declaration of expression        | <kbd>ctrl-alt-down</kbd>    | <kbd>cmd-alt-down</kbd> |
| `ocaml-merlin:go-to-type-declaration`  | Go to type declaration of expression   |                             |                         |
| `ocaml-merlin:return-from-declaration` | Go back to expression                  | <kbd>ctrl-alt-up</kbd>      | <kbd>cmd-alt-up</kbd>   |
| `ocaml-merlin:shrink-selection`        | Shrink the current selection           |                             |                         |
| `ocaml-merlin:expand-selection`        | Expand the current selection           |                             |                         |
| `ocaml-merlin:rename-variable`         | Rename all occurrences of variable     |                             |                         |


## Installation

This package requires [language-ocaml], [linter] and [ocamlmerlin].

```sh
apm install language-ocaml linter
opam install ocamlmerlin
```

[ocamlmerlin]: https://github.com/the-lambda-church/merlin
[linter]: https://atom.io/packages/linter
[autocomplete-plus]: https://atom.io/packages/autocomplete-plus
[language-ocaml]: https://atom.io/packages/language-ocaml
