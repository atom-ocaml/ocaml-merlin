# ocaml-merlin

_Use [ocamlmerlin] to autocomplete, lint and navigate your OCaml code in Atom._


## Usage

Linting is performed on save by [linter]. Autocompletion is performed on the fly by [autocomplete-plus].

There are no default keybindings configured.

| Command                                | Description                           |
| -------------------------------------- | ------------------------------------- |
| `ocaml-merlin:show-type`               | Show type of expression under cursor  |
| `ocaml-merlin:shrink-type`             | Shrink the expression                 |
| `ocaml-merlin:expand-type`             | Expand the expression                 |
| `ocaml-merlin:next-occurrence`         | Find next occurence of expression     |
| `ocaml-merlin:previous-occurrence`     | Find previous occurence of expression |
| `ocaml-merlin:go-to-declaration`       | Go to declaration of expression       |
| `ocaml-merlin:go-to-type-declaration`  | Go to type declaration of expression  |
| `ocaml-merlin:return-from-declaration` | Go back to expression                 |
| `ocaml-merlin:shrink-selection`        | Shrink the current selection          |
| `ocaml-merlin:expand-selection`        | Expand the current selection          |


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
