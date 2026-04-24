# Bill's Helix Cheat Sheet / Command Reference

This started out as a simple cheat sheet but mushroomed into a
comprehensive command reference organized by function.  It is available in us-letter and a4
sizes, in portrait and landscape orientation, and in a dark and light
theme.  It is also available as a poster in portrait and landscape, light
and dark, as single large page or split up as multiple us-letter sized
pages.  Dark is best for reading on screen unless you want to waste a lot
of printer ink or toner.

The layout dimensions were tweaked to align the landscape poster horizontal split boundaries
with column gutters. This is not possible for the vertical split boundaries
and not considered at all for the portrait poster.

Download from the *dist* directory above.

![Reduced dark poster](Images/poster.jpg)

## Development Trajectory
A wise sage once said that the best way to learn a concept is to teach it. I find that preparing
cheat sheets is a great way to explore and learn a new tool. It was in this spirit that I began
my work on this - just as a learning exercise - and from there it expanded to the present form,
which I believe is worthy of sharing.

Initially I thought this would be a subset of the most common commands
from full Helix command set, just enough for basic use.  I started with
the commands in the Helix *tutor* document but soon realized that was not
quite enough and so began adding *just a few* from the *keymap* page.  And
then my OCD *complete set* obsession (*collect them all*, from cereal
boxes in my childhood) set in and I expanded it further to
all of the *keymap* and then *textobjects* pages and even a few
command-line items.

The principle difference between this and the Helix *keymap* and *textobjects* pages is the organization
This is grouped by function instead of by modes, which are often grouped by the initial letter of a command instead
of by the function of the command.

## Why Another?
I like cheat sheets. Once the basic paradigm is understood they are a great way to learn
the the full scope of a tool without reading a large amount of documentation.

There are several Helix cheat sheets already available, the best is likely the one by Steve
Hoy.  Others cover only a small subset of commands and are set over too many
pages for quick reference.  While Steve's looks great when viewed on a screen, parts of it
are illegible when printed because of the shading, light type, and colors.  I wanted a
cheat sheet suitable for quick reference, that would print well, and that would fit on a poster.

## Why Helix - A Personal Story
I have been using the *Rand Editor* since my first experiences with Unix around 1980 -
Wollongong Unix running on Perkin-Elmer hardware.  Since then I bought a release directly
from Rand, acquired another from CERN, found another online, and migrated the code to each
new computing environment I encountered.  Every attempt to convert to Vim, Emacs, VSCode,
etc. was thwarted by muscle memory and a distaste for GUI editors.  It was always just
easier to stick with Rand rather than try to learn something new.  Moreover, the Rand
editor has one feature - *quarter-plane editing model* - that, with the possible exception
of Emacs *picture mode*, no modern editor supports.  That, plus mode-less editing and
muscle memory kept me in the dark ages, editor-wise.

I had a lull in my development work In the winter of 2026 and so decided to finally invest the
time to learn a new editor. I might have been motivated by one of many limitations of Rand -
Unicode support, line length, IDE features, etc. - not sure at this point. My dear friend, ChatGPT, suggested that
the easiest migration path from Rand would be Kakoune or Helix. I settled on Helix because it is
pretty much complete out of the box.

## Links

* [Helix Home Page](https://helix-editor.com/)
* [Helix Documentation](https://helix-editor.com/)
* [Helix Keymap](https://docs.helix-editor.com/keymap.html)
* [Steve Hoy Cheat Sheet](https://github.com/stevenhoy/helix-cheat-sheet)
* [Hidden Monkey Cheat Sheet](https://cheatography.com/hiddenmonkey/cheat-sheets/helix/)
* [Kapeli Cheat Sheet](https://kapeli.com/cheat_sheets/Helix.docset/Contents/Resources/Documents/index)
* [RedOracle Cheat Sheet](https://redoracle.com/Documents/Tutorials/helixCheatSheet.html)
* [Rand Editor Manual](https://www.rand.org/pubs/notes/N2239-1.html)

## Rebuilding
The source for this is `Bills-Helix-Cheat-Sheet.typ`. The following is applicable to *Linux*, the
environment in which it was developed. It will likely be similar for *MacOS* and a bit different for *Windows*.

### Requirements
You will need *typst* to compile and fonts *Adobe Caslon Pro*, *Roboto Mono*,
and *Zilla Slab*.  All fonts, font sizes, and page dimensions are
specified near the top of `Bills-Helix-Cheat-Sheet.typ` where they can be changed should your
opinion on appearance differs from mine. Additional requirements for building
with *make* are shown below.

### Run Typst Directly
Presently, this is hand tuned for *us-letter* and *a4* page sizes only and a fixed poster size.
The poster size is based on six *us-letter* size pages.


|orientation| width | height | columns |
|---|---|---|---|
| portrait | 8.5 * 2 | 11 * 3 | 3 |
| landscape | 11 * 3 | 8.5 * 2 | 6 |

The source includes commented-out experimental code to compute column count from page size for any     
size supported by *typst*. I may consider this for a future release.

Default options are shown first.

```
typst compile <options> Bills-Helix-Cheat-Sheet.typ
```

```
<options>:                 
    --input pagesize=us-letter / a4 / poster / <any supported by typst>
    --input theme=light / dark
    --input orientation=portrait / landscape
    --input show-breaks=true / false            # show page breaks, false for posters
    --input show-index=true / false             # true: include index, usually false for posters
    --input show-toc=false / true               # true: include table of contents, usually false
    --input col-width=12                        # column width in em, used by Build-Poster.py for adaptive builds                  
    --input font-scale=1.0                      # scale for all fonts, used by Build-Poster.py for adaptive builds                  
    --input debug=false / true                  # true: include layout information in Introduction
```
### Split Directly
In addition you will need *pdfposter*. Here are a couple of examples, adjust dimensions to your preference.
```
pdfposter -m 8.5x11in -p 17x33in Bills-Helix-Cheat-Sheet.pdf Bills-Helix-Cheat-Sheet-split.pdf     # portrait
pdfposter -m 11x8.5in -p 33x17in Bills-Helix-Cheat-Sheet.pdf Bills-Helix-Cheat-Sheet-split.pdf     # landscape
```

### Build Using Makefile
In addition you will need *make*, and *fish*.

Build the complete suite:
```
make all
```

Build one .pdf file for testing:
```
make one
make pocket
make poster
make split
```

## Contact
You can reach me via *Contact* at one of my other sites: [What!](https://what.wrwetzel.com) or through github.

# Release History
* 1.0.0, 15-Apr-2026 - Initial release, *us-letter*, *a4*, and locally-defined *poster* paper sizes.
* 1.1.0, 22-Apr-2026 - Added support for all paper sizes recognized by Typst; adaptive build script to fit the
    full document on one sheet or specified number of sheets of any such paper sizes; some refactoring of code; 
    removed examples in lieu of separate future *Quick Start* document; added support for pocket-sized layout.

texlive-binextra
