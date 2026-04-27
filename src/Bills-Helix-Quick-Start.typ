#import "Bills-Cheat-Sheet-Utils.typ": *
#show: template

// =================================================================================
//  Begin front matter
// ---------------------------------------------------------------------------------
//  - Distributed at: \
//  #link( "https://helix.wrwetzel.com")[https://helix.wrwetzel.com]
//      Not yet at my site, maybe never, as just Github appears fine.

#title[ Bill's Helix Quick Start ]
#block(breakable: false)[
= Introduction
#Comment[
This is an excerpt from *Bills Helix Cheat Sheet*. It includes the bare minimum to get started with
the Helix editor. It was prepared in response to a comment from a user of the full cheat sheet.
]   // end #Comment[]
]   // end #block()


#block(breakable: false)[
= Introduction
#Comment[
- Document version: 1.1.0-beta, #today.display( "[day]-[month repr:short]-[year]" )
- Based on #link( "https://helix-editor.com/" )[Helix version: 25.07.1]
- Built with #link( "https://typst.app/" )[Typst version: #sys.version]
- Distributed at: \
  #link("https://github.com/wrwetzel/Helix-Cheat-Sheet")[https://github.com/wrwetzel/Helix-Cheat-Sheet]
- \u{00a9} 2026 Bill Wetzel - Licensed under CC BY 4.0 \
  #link( "https://creativecommons.org/licenses/by/4.0/" )[https://creativecommons.org/licenses/by/4.0/]

//  For debugging only, causes overflow on "poster" size, resolved, keep for future work.

#if Debug_Flag {
    box( context {
      let L = page_layout.get()
      let column_width_em = measure( text( font: ft_command, size: sz_command, weight: "bold" )[M]).width * arg_column_width_em
      set text( fill: colors.fg_color )
      [
    -   *Page*
        Reported Width: _ #calc.round( page.width.inches(), digits: 2)in, _
        Reported Height: _ #calc.round( page.height.inches(), digits: 2)in, _

    -   *Options:*
        Theme: _#theme,_
        Pagesize: _#pagesize,_
        Orientation: _#orientation,_
        Breaks: _#repr(do_breaks),_
        Index: _#repr(do_toc),_
        Arg_column_width: #arg_column_width_em em,
    -   *Fonts:*
        Font_scale: _#calc.round( arg_font_scale, digits: 3), _
        Heading: _#repr( sz_heading ),_
        Comment: _#repr(sz_comment),_
        Cmd: _#repr(sz_command),_
        Def: _#repr(sz_command_def),_
        Toc: _#repr(sz_toc) _

    -   *Layout:*
        Columns: _#L.cols (#L.source), _
        Column_width: _#calc.round( column_width_em.inches(), digits: 2)in _
        Gutter: _#calc.round( L.gutter.inches(), digits: 2)in (#L.source), _
    ] // END text()
    
    }   // END context {}
    )   // END #box()
} // END if Debug_Flag
]   // end #Comment[]
]   // end #block()

// ---------------------------------------------------------------------------------


#block(breakable: false)[
== Examples
#Proc( "
/<regex> / * - search for <regex> / selection
%s<regex> - search entire file for <regex>, then...
c<new><esc> - ... change to <new>
wd / xd - delete word / line
wc / xc - change word / line
wy / xy / %y - yank word / line / entire file
\"ay / \"ap - yank word to reg a / paste reg a
p / P - paste yank after / before cursor
mi(y / mi(c - yank / change contents inside parens
ms( / md( - add / delete parens around selection / under selection
<space>c / <space>C - toggle comment on line under selection / block comment on selection
i<enter><esc> / J - split line at cursor / join to next
C / Alt-C - add selection below / above for multi-edit
Alt-s - split selection on lines for multi-edit
" )
]


= Primary Commands
#block(breakable: false)[
== Essentials
#Proc( "
u / U - undo / redo change in linear history
Alt-u / Alt-U - move backward / forward in tree history
:ear / :lat - move backward / forward in history by step count or time span (1s, 2m, 3h, 4d)
<nn><cmd> - repeat <cmd> <nn> times
Esc - return to normal mode
")
]

