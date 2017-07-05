# ocaml-merlin

_Use [ocamlmerlin] to autocomplete, lint, refactor and navigate your OCaml/Reason code in Atom._


## Features

* Context-sensitive autocompletion and linting
* Show the type of expressions under the cursor
* Find all occurrences of a variable
* Jump to (type) declarations and back
* Shrink and grow selections in a smart way
* Rename all occurrences of a variable in a file
* Destruct expressions in pattern matchings


## Usage

Linting is performed on save or while typing by [linter]. Autocompletion is performed on the fly by [autocomplete-plus].

No default keybindings are provided, except those compatible with the `symbols-view` package. Additional keybindings can be set in your keymap.

| Command                                | Description                            | Keybinding (Linux, Windows) | Keybinding (OS X)       |
| -------------------------------------- | -------------------------------------- | --------------------------- | ----------------------- |
| `ocaml-merlin:toggle-type`             | Toggle type of expression under cursor |                             |                         |
| `ocaml-merlin:shrink-type`             | Shrink the expression                  |                             |                         |
| `ocaml-merlin:expand-type`             | Expand the expression                  |                             |                         |
| `ocaml-merlin:destruct`                | Destruct expression under cursor       |                             |                         |
| `ocaml-merlin:next-occurrence`         | Find next occurrence of expression     |                             |                         |
| `ocaml-merlin:previous-occurrence`     | Find previous occurrence of expression |                             |                         |
| `ocaml-merlin:go-to-declaration`       | Go to declaration of expression        | <kbd>ctrl-alt-down</kbd>    | <kbd>cmd-alt-down</kbd> |
| `ocaml-merlin:go-to-type-declaration`  | Go to type declaration of expression   |                             |                         |
| `ocaml-merlin:return-from-declaration` | Go back to expression                  | <kbd>ctrl-alt-up</kbd>      | <kbd>cmd-alt-up</kbd>   |
| `ocaml-merlin:shrink-selection`        | Shrink the current selection           |                             |                         |
| `ocaml-merlin:expand-selection`        | Expand the current selection           |                             |                         |
| `ocaml-merlin:rename-variable`         | Rename all occurrences of variable     |                             |                         |


## Installation

This package requires [language-ocaml], [linter] and [ocamlmerlin]. For auto-indenting destructed patterns, [ocaml-indent] is needed. For Reason support, [language-reason] is needed, and [reason-refmt] is recommended.

```sh
apm install language-ocaml linter ocaml-indent
opam install merlin
```

[ocamlmerlin]: https://github.com/the-lambda-church/merlin
[linter]: https://atom.io/packages/linter
[autocomplete-plus]: https://atom.io/packages/autocomplete-plus
[language-ocaml]: https://atom.io/packages/language-ocaml
[ocaml-indent]: https://atom.io/packages/ocaml-indent
[language-reason]: https://atom.io/packages/language-reason
[reason-refmt]: https://atom.io/packages/reason-refmt
