# pandoc-citeproc-preamble

## Synopsis

pandoc-citeproc-preamble is a JSON filter for [Pandoc][] which
inserts a preamble before the output that the [pandoc-citeproc][]
filter appends to the document.  This preamble might include a heading
(e.g. "Bibliography") and raw markup to format the bibliography for
the output format.

[Pandoc]: http://pandoc.org/ "Pandoc home page"

[pandoc-citeproc]: http://hackage.haskell.org/package/pandoc-citeproc

## Installation

Users of Debian 10 or later or Ubuntu 17.04 or later: `apt-get install
pandoc-citeproc-preamble`.  Users of Debian 9: enable
[backports][backports], and then `apt-get install -t stretch-backports
pandoc-citeproc-preamble`.

Otherwise, pandoc-citeproc-preamble uses the standard Haskell
toolchain and is available from Hackage, so you should just be able to
`cabal install pandoc-citeproc-preamble`.

If you are not a Haskell programmer, you might find it easier to

1. install [Stack][];
2. ensure that `~/.local/bin` is in your shell's PATH
3. run `stack install pandoc-citeproc-preamble`.

[backports]: https://backports.debian.org/Instructions/
[Stack]: https://github.com/commercialhaskell/stack

## Usage

Add `--filter pandoc-citeproc-preamble` somewhere after `--filter
pandoc-citeproc`, e.g.

    $ pandoc -s --filter pandoc-citeproc --bibliography=~/doc/mine.bib --filter pandoc-citeproc-preamble ~/doc/my_essay.mdwn -o ~/my_essay.pdf

In this case, since the output format is LaTeX,
pandoc-citeproc-preamble will look for the preamble in the file
`data_dir/citeproc-preamble/default.latex` where `data_dir` is your
Pandoc user data directory, as reported by `pandoc --version`.  You
may specify a different preamble by setting document metadata like this:

    $ pandoc ... --filter pandoc-citeproc-preamble -M citeproc-preamble=~/my_preamble.tex ...

Please see "Rationale", below, for why it would defeat the purpose of
this script to include a value for `citeproc-preamble` in your input
file's YAML metadata block.

### Example preamble file

Please see my [~/.pandoc/citeproc-preamble/default.latex][], which
was inspired by [this guide][].

[~/.pandoc/citeproc-preamble/default.latex]: https://git.spwhitton.name/?p=dotfiles.git;a=blob;f=.pandoc/citeproc-preamble/default.latex;hb=HEAD "my default preamble"

[this guide]: http://kieranhealy.org/blog/archives/2014/01/23/plain-text/ "Plain Text, Papers, Pandoc"

## Rationale

One motivation for authoring with Pandoc is that one's input files are
agnostic with regard to the output format they will eventually be
compiled to: it should not be necessary to include in one's input
file, for example, LaTeX code to format the bibliography.

When compiling to PDF (which is probably the most common case for
users of pandoc-citeproc), formatting code is usually required to have
the entries of pandoc-citeproc's bibliography line up with each other;
by default, all entries except the first will be indented.  Another
common customisation is to set up a [hanging indent][] for bibliography
entries.

Since pandoc-citeproc doesn't provide any facility to add formatting
control code to its output, pandoc-citeproc-preamble is necessary to
avoid the user being forced to add their control code to the end of
their input files, thereby losing the input file's agnosticity with
regard to output format.

[hanging indent]: http://www.computerhope.com/jargon/h/hanginde.htm "description of hanging indent"

## Bugs

Please report bugs by e-mail to `<spwhitton@spwhitton.name>`.

## License

Copyright (C) 2015-2016, 2019  Sean Whitton

pandoc-citeproc-preamble is free software: you can redistribute it
and/or modify it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

pandoc-citeproc-preamble is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with pandoc-citeproc-preamble.  If not, see
[<http://www.gnu.org/licenses/>](http://www.gnu.org/licenses/).
