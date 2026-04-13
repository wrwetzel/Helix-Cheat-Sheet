# Bill's Helix Cheat Sheet / Command Reference

This started out as a simple cheat sheet but mushroomed into a
comprehensive command reference organized by function.  It is available in us-letter and a4
sizes, in portrait and landscape orientation, and in a dark and light
theme.  It is also available as a poster in portrait and landscape, light
and dark, as single large page or split up as multiple us-letter sized
pages.  Dark is best for reading on screen unless you want to waste a lot
of printer ink or toner.

Download from the *src* directory above.

![Reduced dark poster](Images/poster.jpg)

## Development Trajectory
Initially I thought this would be a subset of the most common commands from full Helix command set,
just enough to get started.
I started with the commands in the Helix *tutor* document but soon realized that was not
quite enough and so began adding *just a few* from the *keymap* page. And then my OCD *complete set*
obsession (*collect them all* from childhood cereal boxes) got the better of me and I expanded it further
to all of the *keymap* and then *textobjects* pages and even a few command-line commands.

The principle difference between this and the Helix *keymap* and *textobjects* pages is the organization,
which is by function instead of by modes, which are often organized by the initial letter of a command instead
of the function of the command.

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
The source for this is `Bills-Helix-Cheat-Sheet.typ`.  You will need *typst* to compile
it, the *fish* shell and *make* if you want to run *make* and *Build.fish* to build the
full suite of sizes, and *Adobe Caslon Pro*, *Roboto Mono*, and *Zilla Slab* fonts.  All
fonts, font sizes, and page dimensions are specified near the top of
`Bills-Helix-Cheat-Sheet.typ` should your opinion on appearance differs from mine.  If you
don't want to muck around with *fish* or *make* you can rebuild with built-in defaults with the
following:

```
typst compile Bills-Helix-Cheat-Sheet.typ
```
The Makefile includes recipies for building just one size for testing:
```
make one
make poster
make split
```
And for building the complete suite:
```
make all
```

## Contact
You can reach me via *Contact* at one of my other sites: [What!](https://what.wrwetzel.com) until I build a site for this.

