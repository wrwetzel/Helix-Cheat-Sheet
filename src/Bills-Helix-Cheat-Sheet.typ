// ---------------------------------------------------------------------------------
//  Helix_Cheat-Sheet-WRW.typ - WRW began around the end of March, 2026.
// ---------------------------------------------------------------------------------

//  Building:
//      typst compile <options> Bills-Helix-Cheat-Sheet.typ <ofile>

//          --input debug=false / true
//          --input pagesize=us-letter / a4 / poster    Any Typst-supported size
//          --input theme=light / dark
//          --input orientation=portrait / landscape
//          --input show-breaks=true / false            false for posters
//          --input show-index=true / false             false for posters
//          --input show-toc=false / true               New option, independent of 'poster'
//          --input col-width=60                        For adaptive testing, in em of ft_command bold
//          --input font-scale=1.0                      For adaptive testing
//          --input fit=false / true                    Also do computed for us-letter, a4, poster

// ---------------------------------------------------------------------------------
//  Todo:
//      Think about dict structure for storing index so can sort on command and section number.
//      #arr.sorted(key: it => (it.cmd, it.section))
//      Maybe migrate to commands in external file with notation for basics/quick-reference.
//      Why us-letter and ansi-a differ on column count with adaptive build? OK with column size of 60em.

// ---------------------------------------------------------------------------------
/*
    Notes:

    Strip trailing space, artifact of the Rand editor:
        sed -i 's/[[:space:]]*$//' <file>

    #block(breakable: false)[...] used to prevent splitting enclosed content at page
        or column boundaries.

    Example of returning values from function respecting function scope limits.

    #let test_fcn( arg1 ) = {
        let a = 3 * arg1
        let b = arg1 / 3
        let c = arg1 + 3
        ( a: a, b: b, c: c )    // last expression evaluated is returned
    }

    #let t = test_fcn( 10 )
    #text( fill: rgb( "#ffffff" ))[ a: #t.a, b: #t.b, #t.c ]

    Extract values from context but still has to be done in context where use result.

    #context {
        let L = layout.get()
        let sz_command = L.font-size
        let sz_command_def = L.font-size + 1pt
    }

    Width of M of 10pt font is around 6pt. "M" was measuring quotes, too.
*/

// =================================================================================
//  Global values
// ---------------------------------------------------------------------------------

#let default_column_width_em = 60       // Fixed width of columns, derrived empirically.

// ---------------------------------------------------------------------------------
//  Pick up command-line options. Options are strings, convert to boolean or float as needed.

#let Debug_Flag =           if sys.inputs.at( "debug", default: "false") == "true" { true } else { false }
#let theme =                sys.inputs.at("theme", default: "light")
#let pagesize =             sys.inputs.at("pagesize", default: "us-letter")
#let orientation =          sys.inputs.at( "orientation", default: "portrait")

#let Fit_Flag =             if sys.inputs.at( "fit", default: "false") == "true" { true } else { false }
#let do_breaks =            if sys.inputs.at( "show-breaks", default: "true") == "true" { true } else { false }
#let do_index =             if sys.inputs.at( "show-index", default: "true") == "true" { true } else { false }
#let do_toc =               if sys.inputs.at( "show-toc", default: "false") == "true" { true } else { false }

#let arg_column_width_em =  float( sys.inputs.at("col-width", default: default_column_width_em ))
#let arg_font_scale =       float( sys.inputs.at("font-scale", default: "1.0"))

// ---------------------------------------------------------------------------------
//  Font and size specification for four functions. These suitable for ~3.25" columns
//  These are scaled by arg_font_scale for page fit.

#let sz_heading = 10pt * arg_font_scale                     // Headings scaled from this size.
#let ft_heading = "Adobe Caslon Pro"

#let sz_comment = 10pt * arg_font_scale                     // Comment text below headings
#let ft_comment = "Adobe Caslon Pro"

#let sz_command =  8pt * arg_font_scale                     // Command
#let ft_command = "Roboto Mono"

#let sz_command_def =  9pt * arg_font_scale                 // Definition. 9pt Zilla Slab matches 8pt Roboto Mono
#let ft_command_def = "Zilla Slab"

#let sz_toc = 8pt * arg_font_scale                          // Table of contents
#let ft_toc = "Adobe Caslon Pro"

// ---------------------------------------------------------------------------------
//  Command box specifications

#let bx_radius = 3pt
#let bx_inset = 8pt
#let bx_stroke = .5pt

// -------------------------------------------------------------------------------
//  Cheating a bit with specific chars defs so I don't have to translate <space> in #Comment
//  To do so will have to convert all #Comment[] calls to use strings, not possible, comments
//  include formatting.

#let ch_space = text(font: ft_command, "\u{2423}", weight: "bold", size: sz_command )
#let ch_spacec = text(font: ft_command, "\u{2423}c", weight: "bold", size: sz_command )
#let ch_spacew = text(font: ft_command, "\u{2423}w", weight: "bold", size: sz_command )
#let cd_sep = " - "     // "command - definition" separator for splitting/joining, not for output.

#let today = datetime.today()

// ===============================================================================
//  Layout / appearance functions
// -------------------------------------------------------------------------------
//  Color specifications: bg - background, fg - foreground, bx - box background fill
//      A few for later exploration:
//          rgb( "#3b224c" )    Dark purple to align with Helix site theme, too light
//          rgb( "000040" )     Dark blue
//          rgb( "#fff0ff")     Light purple, I like light blue better.

#let get_colors() = {
    if theme == "light" {
        (bg_color: rgb( "#ffffff" ), fg_color: rgb( "#000000" ), bx_color: rgb( "#f0f0ff") )
    } else {
        (bg_color: rgb( "#3b224c" ), fg_color: rgb( "#ffffff" ), bx_color: rgb( "#4b325c") )
    }
}

// ---------------------------------------------------------------------------------
//  Page layout and size specifications

//  WRW 17-Apr-2025 - set page size explicitly via 'mx', 'my' for "poster", via 'paper' for all else.
//  Poster dimensions set here.
//  page.width, page.height do not change when 'flipped: true' for named sizes.
//  Keep explicit dimensions for portrait and landscape the same to be consistent with named sizes
//  as we later flip them for landscape.

#let get_page_params() = {

    if pagesize == "poster" {               //  17 h x 33 v, Portrait poster
        if orientation == "portrait" {        
            ( gutter: .25in,
              mx: .6in,
              my: .6in,
              paper: none,
              flipped: false,
              column_count: 3,      // 4 put break in gutter but had an empty column
              pw: 8.5in * 2,
              ph: 11in * 3
            )

        } else {                            // 33 w x 17 h, Landscape poster
            ( gutter: .75in,                // .75in centers the gutter on the page break
              mx: .75in,
              my: .75in,
              paper: none,
              column_count: 6,
              // flipped: false,
              // pw: 11in*3,
              // ph: 8.5in * 2
              flipped: true,
              pw: 8.5in * 2,                       
              ph: 11in * 3

           )
        }

    } else {    // anything else including us-letter or a4
        let ( flipped, column_count ) = if orientation == "portrait" { ( false, 2 ) } else { ( true, 3 ) }
        ( gutter: .25in,
          mx: .6in,
          my: .6in,
          paper: pagesize,
          flipped: flipped,
          column_count: column_count,
          pw: none,
          ph: none
        )
    }
}

//  ----------------------------------------------------------------------------------------------
//  Assign values conditionally to page_args to use width:/height: or paper:.
//  This is the only way to have conditional args to #set page(). Putting #set page() in
//  a conditional block limited scope to the block, not global.
//  A reminder that the last expression evalulated is the return value for the function.

#let get_pa( pp, colors ) = {
    if pagesize == "poster" {
            (
            columns: pp.column_count,
            margin: (x: pp.mx, y: pp.my ),
            width: pp.pw,
            height: pp.ph,
            flipped: pp.flipped,
            fill: colors.bg_color,
            )
        } else {
            (
            columns: pp.column_count,
            margin: (x: pp.mx, y: pp.my ),
            paper: pp.paper,
            flipped: pp.flipped,
            fill: colors.bg_color,
            )
        }
}

// -------------------------------------------------
//  This appears to solve the problem of context, scope, and getting values
//  out of context with state().
//  source just for debugging messages in the cheat sheet
//  Must be called inside a context block, reads page intrinsics.
//  Returns dict: (cols, gutter, margin, source ).      

//  /// RESUME: Need to include gutter in 'usable' computation here?

#let calc-layout( col-width: none, margin: none ) = {

    let logical_page_width = if orientation == "portrait" { page.width } else { page.height }
    let usable    = logical_page_width - margin * 2     // WRW 22-Apr-2026
    let col_cnt   = calc.max(1, calc.floor(usable / col-width))
    let gutter    = calc.max( 0.25in, col-width * 0.1)

    (cols: col_cnt, gutter: gutter, margin: margin, source: "Computed" )
}

// ==========================================================================
//  *** Global layout. ***

//  I tried moving the "#show: rest context{...}" below into a function but stumbled 
//      on scope and context issues. Keep it in global scope.

//  Hand-tuned parameters for us-letter, a4, and 'poster'. Computed for all other sizes by calc-layout()
//  Fit_Flag set in Build-Adaptive.py to force computed for all including us-letter, a4, and poster.

// --------------------------------------------------------------------------
//  Can't include "..pa" in "set page( columns: L.cols )" below because 'columns:' appears in both.
//  set page() overrides columns with computed value for adaptive use.

#let colors = get_colors()
#let pp = get_page_params()
#let pa = get_pa( pp, colors )
#set page( ..pa )       

#let layout = state("layout", (cols: 0, gutter: 0pt, font-size: 10pt))  //  Declare state with a default

#show: rest => context {
    let column_width_em = measure( text( font: ft_command, size: sz_command, weight: "bold" )[M]).width * arg_column_width_em

    //  Keep hand-tuned dimensions for common sizes for page fit, compute all the rest.

    let L = if not Fit_Flag and (pagesize == "us-letter" or pagesize == "a4" or pagesize == "poster") {
        ( cols: pp.column_count, gutter: pp.gutter, margin: pp.mx, source: "Specified" )

    } else {
        calc-layout( col-width: column_width_em, margin: pp.mx )        // Computed
    }

    layout.update(L)                        // Save it in state

    set page( columns: L.cols )             // Override columns with value computed in context for adaptive.
    set columns( gutter: L.gutter )
    rest
}

// Default foreground text color, font, size for whole document including title and headings.

#set text( fill: colors.fg_color, font: ft_heading, size: sz_heading )      // heading scale from this
#set heading(numbering: "1.1")

// ==========================================================================
//  Function definitions for setting content
// --------------------------------------------------------------------------
//  Data store for Command Index

#let my_index = state( "index", () )
#let add_index_item( item ) = {
    my_index.update( arr => arr + (item,) )
}

// ---------------------------------------------------------------------------------
//  Content under heading, above commands and definitions
//  WRW 20-Apr-2026 - Tried to replace "<space>" here but failed. Need to convert
//      calls to Comment to use strings, not content, if want to do that, but then lose formatting.
//      Ok to live with ch_space, etc.

#let Comment( body ) = {
    context {
        set text(font: ft_comment, size: sz_comment )
        set par( leading: 0.5em )
        body
    }
}

// ---------------------------------------------------------------------------------
//  Helper for Proc(). Will only have section number (1.2.3) on second pass when setting index.

#let proc_def( def ) = {
    set par(leading: 0.4em)     // space between lines, just like cold-type leading

    let m = def.match(regex("^(.*?)(\(\d+(?:\.\d+)*\))$"))
    if m != none {                  // Match on index pass (second pass)
        let before = m.captures.at(0)
        let number = m.captures.at(1)

        context {
            text(font: ft_command_def, size: sz_command_def )[#before#text(weight: "bold")[#number]]
        }

    } else {                        // No match because no (1.2.3) on first pass, just set argument in call
        context {
            text(font: ft_command_def, size: sz_command_def )[#def]
        }
    }
}

// -----------------------------------------------------------------------------------
//  cd_sep - separates the command from def in the input, not in the output
//  #sym.dash.en - separator for output

//  Arguments:
//      lines - string containing newline-separated "cmd - definition" pairs.
//      no_index: - Don't add 'lines' to index, used for some front matter.

#let Proc( lines, no_index: false, cmd_width: 0 ) = {
    context {
        let L = layout.get()
        let max_cmd_width = 0em

        let cells = ()

        //  Don't know where 'none' lines came from during development. OK now, no need for check.
        //  if lines != none {

            //  Build array of cells to set on completion of loop.

            for line in lines.split("\n") {
                let line = line.trim()

                // ----------------------------------
                // Dash in input to show blank line to separate groups of commands within one table.

                if line == "-" {
                    cells = cells + (table.cell(colspan: 3 )[ ], )
                }

                // ----------------------------------
                //  Something on line

                else if line.len() > 0 {
                    let parts = line.split( cd_sep )
                    let cmd = parts.at(0).replace("<space>", "\u{2423}").replace( "<comma>", "," )  // substitutions are for display, not building index

                    let t = measure( text( font: ft_command, size: sz_command, weight: "bold" )[#cmd]).width
                    t += measure( text(font: ft_command, size: sz_command )[#sym.dash.en]).width
                    max_cmd_width = calc.max( max_cmd_width, t )

                    // ----------------------------------
                    // Command and Definition

                    if parts.len() >= 2 {
                            let def = parts.slice(1).join( cd_sep )
                            cells = cells + (
                                text(font: ft_command, size: sz_command, weight: "bold" )[#cmd],
                                text(font: ft_command, size: sz_command )[#sym.dash.en],       // set the output separator
                                proc_def( def )
                            )

                        // -------------------------------
                        // Build index unless arg indicating not to

                        if not no_index {
                            let s = numbering("1.1", ..counter(heading).get())  // string
                            add_index_item( line + " (" + s + ")" )
                        }

                    // ----------------------------------
                    // Just Command, no Definition

                    } else {
                        cells = cells + (
                            table.cell(colspan: 3, align: left )[#text(font: ft_command, size: sz_command, weight: "bold" )[#cmd]],
                        )
                    }
                }
            }

        // } else {    // Saw a 'none' lines during development, show a message to see where.
        //     cells = cells + [none line here "foobar"]
        // }

        // ------------------------------------------
        //  Show cells containing Command / Definition accumulated above.

        //  Limit cmd to no more than 50% of column, no less than 20%. 50% was greatest needed
        //      when manually adjusting.
        //  WRW 22-Apr-2025 - A nasty bug, I was not using correct dimensions for flipped (landscape) pages.
        //      page.width and page.height are fixed, do not change when page flipped for landscape. Ouch!
        //      Nor dividing by column count. All good now.

        let column_width_em = measure( text( font: ft_command, size: sz_command, weight: "bold" )[M]).width * arg_column_width_em
        let logical_page_width = if orientation == "portrait" { page.width } else { page.height }
        let computed_col_width = ( logical_page_width - ( (L.cols - 1) * L.gutter + L.margin * 2) ) / L.cols

        max_cmd_width = calc.min( max_cmd_width, computed_col_width * .5 )     // Upper limit of 50%
        max_cmd_width = calc.max( max_cmd_width, computed_col_width * .2 )     // Lower limit of 20%

        //  NOTE: inset: (x: -2em ) required to compensate for some offset in the table left padding
        //      which I bumped up against when setting an absurdly small size of the entire cheat-sheet
        //      on us-letter just for testing. No good to keep - it also shifted the other columns

        //      Inter-column gutter in table established by "#sym.dash.en", no further needed.

        max_cmd_width = if cmd_width > 0 { computed_col_width * cmd_width } else { max_cmd_width }

        block(fill: colors.bx_color, inset: bx_inset, radius: bx_radius, width: 100%, stroke: bx_stroke)[
            #table(
                columns: ( max_cmd_width, auto, 1fr ),      // cmd, gutter, def
                stroke: none,
                inset: (x: .2em, y: .2em),                  // surrounding each line in table
                align: (right, center, left),
                row-gutter: 0pt,
                ..cells
            )
        ]  // End of block()

    } // End of context
}

// ---------------------------------------------------------------------------------
//  Show the index accumulated in my_index.
//  Remove blank/whitespace-only lines, probably already removed above.
//  This is set in a second pass using the same Proc() call as in the first pass.

#let show_index() = {
    context {
        let index = my_index.get().filter(line => line != "-").filter(line => line.trim() != "")
        let lines = ()

        for line in index {
            let parts = line.split( cd_sep )
            let cmd = parts.at(0).replace("<space>", "\u{2423}")
            let def = parts.slice(1).join( cd_sep )

            let synonyms = cmd.split( "," )            // Show each synonym as separate index item
            for synonym in synonyms {
                let s = ( synonym.trim() + cd_sep + def )
                lines = lines + ( s, )
            }
        }

        //  Call Proc() again to set the index, this time with no_index set.
        //  Substitutions here with replace() are only for sorting, not setting.

        Proc( lines.sorted( key: e => e.replace( "\u{2423}", " " ).
                                        replace( "<space>", " " ).
                                        replace( "<comma>", "," )
                          ).join( "\n" ), no_index: true, cmd_width: .33 )       // Sort after add synonyms
    }
}

// =================================================================================
//  Begin front matter
// ---------------------------------------------------------------------------------
//  - Distributed at: \
//  #link( "https://helix.wrwetzel.com")[https://helix.wrwetzel.com]
//      Not yet at my site, maybe never, as just Github appears fine.

#title[ Bill's Helix Cheat Sheet / Command Reference ]

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
      let L = layout.get()
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
== Definitions
#Comment[
- *file* - the actual data on storage device
- *buffers* - data from one or more files loaded into memory
- *view* - one or more visual areas on screen showing one or more buffers
- *workspace* - the directory from which Helix was launched
- *under selection* - the entire word containing the cursor, not just the selection
- *alternate buffer* - the previous active buffer
- *textual line* - text as defined by the newline character
- *visual line* - what appears on screen after word-wrapping
- *range* - a selection; one in single-selection, multiple in multi-selection
]
]

#block(breakable: false)[
#show raw: it => text(font: ft_command, weight: "bold", size: sz_command )[#it.text]
== Typographic Conventions
#Comment[
- `word` - alphanumeric, punctuation-delimited
- `WORD` - whitespace-delimited
- `Ctrl-c` - Ctrl and c key pressed simultaneous.
- `Alt-c` - Alt and c key pressed simultaneous.
- Some Alt and Ctrl characters may conflict with terminal capture and require terminal configuration change.
- #ch_spacec is space followed by the character c.
- Metavars `<regex>`, `<file>` and `<ch>` represent user input. The angle-brackets are not part of the input.
- #ch_space, `<minus>`, and `<under>` used for clarity.
  `<enter>`, `<del>`, `<bksp>`, etc. used for non-printing control characters.
- Commands are separated from definitions by a dash. Synonyms are separated by commas.
  Related commands are separated by slashes.
  The separators are never part of the command though commands may include a dash, comma, or slash.
]
]

#block(breakable: false)[
== Regular Expressions
#Comment[
Helix uses Rust's regex.
Escape following metachars with \<backslash\> when searching for literal value.
]

#Proc( "
. - any character
* - zero or more
+ - one or more
? - zero or one / lazy match
^ - start of line / negation in class
$ - end of line
( ) - capture group
[ ] - character class
{ } - repetition count
| - alternation
\ - escape character itself
", no_index: true )
]

#block(breakable: false)[
== Launching
#Comment[
#text(font: ft_command, size: sz_command )[
- *helix*
- *helix* \<file\>
- *helix* \<file1\> \<file2\> ... \<filen\>
- *helix* \<directory\>
- *helix* --help
- *hx* in some distributions or by alias
] // END text()
] // END Comment
] // END block()

// --------------------------------------------------------------------------------

#block(breakable: false)[
== Basics
#Comment[
Editing paradigm: select first, action second.
_mode_ and _count_ are optional.
]
#Proc( "
[mode][count][select][command]
", no_index: true )

#Proc( "
v3wd - enter select mode, select 3 words, delete
", no_index: true )
]

/*  WRW 21-Apr-2026 - Omit - I don't like this, redundant with other content.
    Not really examples, just selected commands.
    Make a separate document with a subset of the commands as quick reference.

        //  Add multi-cursor example
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
        ", no_index: true )
        ]
*/

/* - Regular Expressions caused page overflow, Modes are less important, omit Modes.

    #block(breakable: false)[
    == Modes
    #Comment[
    As used in Helix documentation.
    ]

    #Proc( "
    : - command
    i - insert
    v - select or extend
    z - view - change view preserving selection
    g - goto
    m - match
    Ctrl-w - window
    <space> - space
    [, ] - unimpaired
    ", no_index: true )
    ]
*/

// =================================================================================
//  Begin commands
// ---------------------------------------------------------------------------------

// #if do_breaks {
//     pagebreak()
// }

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

#block(breakable: false)[
=== Quit
#Comment[
Add *!* suffix to force operation.
]
#Proc( "
:wq - write current buffer and quit
:wq <file> - write current buffer to <file> and quit
:wqa - write all buffer(s) and quit
:q - quit current buffer, exits if last
")
]

#block(breakable: false)[
=== Files
#Proc( "
:o <file> - open <file> in new buffer
:w <file> - write current buffer to <file>
-
:hs <file> - open/create <file> in new horizontal split
:vs <file> - open/create <file> in new vertical split
<space>wf - open/create file(s) under selection(s) in horizontal split
<space>wF - open/create file(s) under selection(s) in vertical split
gf - open/create file(s) under selection, open url under selection.
-
<space>f - open file picker at LSP workspace root
<space>F - open file picker at current working directory
<space>g - open changed file picker
")
]

#block(breakable: false)[
==== File Picker
#Comment[
All pickers, here and elsewhere, are _fuzzy_ - they tolerate gaps in the input, ranking closer matches higher.
]
#Proc( "
<enter> - open selected in current view
Ctrl-s - open selected in new horizontal split
Ctrl-v - open selected in new vertical split
")
]

#block(breakable: false)[
=== Buffers
#Comment[
Add *!* suffix to force operation.
Buffers named by file they contain.
]
#Proc( "
:n - create new scratch buffer
:bc - close current buffer
:bca - close all buffers
:bco - close all but current buffer
:bn - next buffer
<space>b - open buffer picker
-
ga - go to last accessed/alternate buffer
gm - go to last modified/alternate buffer
gn - go to next buffer
gp - go to previous buffer
")
]

#block(breakable: false)[
=== Views
#Comment[
Ctrl-w and #ch_spacew are synonymous.
]
#Proc( "
<space>ws / <space>wv  - split horizontal / vertical, current buffer
<space>wns / <space>wnv - split horizontal / vertical, new buffer
<space>wq - close current split
<space>wo - close all but current split
<space>ww - next split
-
<space>wh/j/k/l - move to buffer left / up / down / right
<space>wH/J/K/L - swap split with buffer on left / up / down / right
<space>wt - transpose split
")
]

#block(breakable: false)[
==== View Movement
#Comment[
Commands shown with *z* prefix. The prefix is not used in sticky mode,
which is a view-only navigation mode appropriate for browsing a file without editing.
]

#Proc( "
Z - enter sticky mode, exit with Esc
-
zz, zc - align to center
zt - align to top
zb - align to bottom
zm - align to middle horizontally
zj - scroll down
zk - scroll up
")
]

#block(breakable: false)[
=== Help
#Proc( "
:tutor - open tutorial
<space>? - open command palette
")
]


// ---------------------------------------------------------------------------------

== Movement
#block(breakable: false)[
=== Cursor Movement
#Comment[
_Normal Mode_: motion replaces selection\
_Select Mode_: motion extends selection\
]
#Proc( "
h/j/k/l - left / up / down / right
gh, g| - beginning of line
<nn>g| - column <nn>
gl - end of line
gg - top of file
<nn>G, g<nn>g - line <nn>
ge - bottom of file
gw - two-char labels on words, label to go to word
-
g. - to last modification in current file
gj - down textual line
gk - up textual line
-
gs - first non-white-space char
gt - top of screen
gc - middle of screen
gb - bottom of screen
")
]

#block(breakable: false)[
=== By Language Server Protocol
#Comment[
Requires LSP support.
]
#Proc( "
gd - go to definition
gy - go to type definition
gr - go to references
gi - go to implementation
-
]d - next diagnostic
[d - prior diagnostic
]D - last diagnostic
[D - first diagnostic
")
]

#block(breakable: false)[
=== By Treesitter - Syntax
#Comment[
Requires Treesitter support.
]
#Proc( "
]f, [f - to next, prior function
]t, [t - to next, prior type definition
]T, [T - to next, prior test
]a, [a - to next, prior arg
]c, [c - to next, prior comment
]g, [g - to next, prior change
]G, [G - to last, first change
-
Alt-e - move to end of parent node in syntax tree
Alt-b - move to start of parent node in syntax tree
")
]

#block(breakable: false)[
=== By Page
#Proc( "
Ctrl-b - page up
Ctrl-f - page down
Ctrl-u - half page up
Ctrl-d - half page down
")
]

// ---------------------------------------------------------------------------

#block(breakable: false)[
== Selection
#Comment[
Selection: a range of characters between anchor and cursor\
_Normal Mode_: move and select\
_Select Mode_: move and extend selection\
]

=== Operations
#Proc( "
% - select whole file
Alt-; - swap anchor and cursor
Alt-: - selection to normal direction (cursor at end)
Alt-o - expand selection syntax-aware
Alt-i - shrink selection
; - collapse selection(s) to cursor(s)
")
]

#block(breakable: false)[
=== By TextObjects
#Proc( "
ma<ch> / mi<ch> - match around / inside the object indicated by <ch> below:
-
w / W - word / WORD
p - paragraph
(, [, ', etc. - specified surround pairs
m -  closest surround pair
f - function
t - type or class
a - argument/parameter
c - comment
T - test
g - change git hunk
")
]

#block(breakable: false)[
=== By Syntactic Objects
#Proc( "
w / W - to start of next word / WORD
e / E - to end of current word / WORD
b / B - to start of current word / WORD
x - current line, extend by line
X - extend to line
Alt-x - shrink to line bounds
]p - to next paragraph
[p - to prior paragraph
")
]

#block(breakable: false)[
=== By Treesitter - Syntax
#Comment[
Requires Treesitter support.
]
#Proc( "
Alt-o - expand selection to parent syntax node
Alt-i - shrink syntax tree object selection
Alt-p - select previous sibling node in syntax tree
Alt-n - select next sibling node in syntax tree
Alt-a - select all sibling nodes in syntax tree
Alt-I - select all children nodes in syntax tree
")
]

#block(breakable: false)[
=== By Character Value
#Comment[
_Lower case:_ forward\
_Upper case:_ backward
]
#Proc( "
f<ch>, F<ch> - to <ch> inclusive (find)
t<ch>, T<ch> - to <ch> exclusive (till)
Alt-.  - repeat last find / till
")
]


#block(breakable: false)[
== Select Mode
#Comment[
_Movement_: extends selection\
_Search_: adds to selection
]
#Proc( "
v - toggle select mode
Esc - return to normal
) - cycle primary selection forward
( - cycle primary selection backward
Alt-<comma>  - remove primary selection
")
]

// ---------------------------------------------------------------------------------

#block(breakable: false)[
== Multiple Selections
#Comment[
Multiple independent cursors / selections, one is _primary_.
]

=== Creating
#Comment[
Create multiple selections from selection.
]
#Proc( "
s<regex> - matches become selections
S - split on match
Alt-s - split on newlines
C / Alt-C - add selection below / above
")
]

#block(breakable: false)[
=== Operations
#Proc( "
& - align on primary cursor
Alt-<minus> - merge selections
Alt-<under> - merge consecutive selections
<comma>  - remove all except primary selection
Alt-<comma>  - remove primary selection
( / ) - rotate primary backwards / forwards
Alt-( / Alt-) - rotate content backward / forward
K - keep selections matching the regex
Alt-K - remove selections matching the regex
")
]


// ---------------------------------------------------------------------------------

== Alter Buffer Content
#block(breakable: false)[
=== Insert
#Proc( "
i - before selection
a - after selection
I - at start of line
A - at end of line
o - add line and insert below cursor
O - add line and insert above cursor
Esc - end insert (return to normal)
. - repeat last insert
")
]


#block(breakable: false)[
=== Add
#Proc( "
]<space> - newline below
[<space> - newline above
ms<ch> - add delim <ch> around selection
")
]

#block(breakable: false)[
=== Delete
#Proc( "
d - selection -> yank buf, delete selection
Alt-d - delete, no save
md<ch> - delete delim <ch> around selection
")
]

#block(breakable: false)[
=== Change
#Proc( "
c - selection -> yank buf, change selection
Alt-c - change, no save
= - format by LSP
mr<ch1><ch2> - replace delim <ch1> with <ch2>
")
]

#block(breakable: false)[
=== Indent Lines
#Proc( "
> - Indent line(s) containing selection
< - Undent line(s) containing selection
")
]

#block(breakable: false)[
=== Change Case
#Comment[
Change case of all letters in selection
]
#Proc( "
~ - change case
` - set lowercase
Alt-` - set uppercase
")
]

#block(breakable: false)[
=== Comments
#Comment[
All apply to selection.
]
#Proc( "
<space>c, Ctrl-c - Toggle comment
<space>C - Toggle block comment
<space>Alt-C - Toggle line comment
")
]

#block(breakable: false)[
=== Increment / Decrement
#Proc( "
Ctrl-a - increment the selected number
Ctrl-x - decrement the selected number
")
]

#block(breakable: false)[
=== Miscellaneous
#Proc( "
J - join lines in a selection
Alt-J - join lines inside selection and select the inserted space
<under> - trim whitespace from selection
:reflow <width> - wrap selection to <width>, default 80
:sort - sort ranges in selection
:format - format file using external formatter / language server
")
]


#block(breakable: false)[
== Copy / Paste / Replace
#Proc( "
y - selection -> yank buf
p - paste yank buf after the cursor
P - paste yank buf before the cursor
<space>y - yank selection(s) -> system clipboard
<space>Y - yank main selection -> system clipboard
<space>p / <space>P - paste clipboard after / before selections(s)
<space>R - replace selection(s) with clipboard
r<ch> - replace selection with <ch>
R - replace selection with yank buf
\" - select register to yank to or paste from
")
]

#block(breakable: false)[
== Search
#Proc( "
/<regex> - search forward for regex
?<regex> - search backward for regex
n, N - next, previous match
* - search for current selection, respect word boundaries
Alt-* - search for current selection
")
]

#block(breakable: false)[
== Registers
#Comment[
Identified by single char \<ch\>
#Proc( "
\"<ch> - change to reg <ch>
\"<ch>y - yank into reg <ch>
\"<ch>p - paste from reg <ch>
\"<ch>R - replace with reg <ch>
")
]
]

#block(breakable: false)[
== Macros
#Proc( "
\"<ch>Q - toggle capture to reg <ch>, default @
\"<ch>q - play macro in reg <ch>, default @
")
]

#block(breakable: false)[
== Jumplists
#Proc( "
Ctrl-s - save current position to jumplist
Ctrl-i - move forward in jumplist
Ctrl-o - move backwards in jumplist
<space>j - open jumplist picker
")
]

#block(breakable: false)[
== Match Mode
#Comment[
With regard to balanced delimiters.
]
#Proc( "
mm - go to matching delim
mi<ch> - match inside delim <ch>
ma<ch> - match around delim <ch>
ms<ch> - add delim <ch> around selection
md<ch> - delete delim <ch> around selection
mr<ch1><ch2> - replace delim <ch1> with <ch2>
")
]

#block(breakable: false)[
== Shell
#Comment[
All commands pipe each selection to shell command.
]

#Proc( "
| - replace selection(s) with output
Alt-| - ignore output
! -  insert output before each selection(s)
Alt-! -  append output after each selection(s)
$ -  keep selection(s) where command returned 0
")
]

#block(breakable: false)[
== Approaching an IDE

#Proc( "
<space>G - debug - experimental
<space>k - show documentation for item under cursor
<space>s - open document symbol picker
<space>S - open workspace symbol picker
<space>d - open document diagnostics picker
<space>D - open workspace diagnostics picker
<space>r - rename symbol
<space>a - apply code action
<space>h - select symbol references for symbol under cursor
")
]

#block(breakable: false)[
== Editor Configuration
#Proc( "
:config-open - open the config file
:config-open-workspace - open the workspace config file
:config-reload - reload the config file
")
]

#block(breakable: false)[
== Miscellaneous
#Proc( "
<space>' - open last picker
<space>/ - open global search in workspace folder picker
")
]

// #if do_breaks {
//     pagebreak()
// }

= Commands in Specific Contexts

#block(breakable: false)[
== Insert Mode Editing
#Comment[
Navigation keys shown.
]
#Proc( "
Ctrl-s - commit undo checkpoint
Ctrl-x - autocomplete
Ctrl-r - insert a register content
Ctrl-w, Alt-<bksp> - delete previous word
Alt-d, Alt-<del> - delete next word
Ctrl-u - delete to start of line
Ctrl-k - delete to end of line
Ctrl-h, <bksp>, Shift-<bksp> - delete previous char
Ctrl-d, <del> - delete next char
Ctrl-j, <enter> - insert new line
-
<Up>, <Down>, <Left>, <Right>, <PageUp>, <PageDown>, <Home>, <End> - usual meaning but discouraged
")
]

#block(breakable: false)[
== Command Line Editing
#Proc( "
Esc, Ctrl-c - close prompt
<enter> - open selected
<tab> - select next completion item
<backtab> - select previous completion item

Alt-b - backward a word
Ctrl-b - backward a char
Alt-f - forward a word
Ctrl-f - forward a char
Ctrl-e - to prompt end
Ctrl-a - to prompt start

Ctrl-w, Ctrl-<bksp> - delete previous word
Alt-d, Ctrl-<del> - delete next word
Ctrl-u - delete to start of line
Ctrl-k - delete to end of line
<bksp>, Ctrl-h - delete previous char
<del>, Ctrl-d - delete next char

Ctrl-s - insert a word under doc cursor (may be changed to Ctrl-r Ctrl-w later)
Ctrl-p - select previous history
Ctrl-n - select next history
Ctrl-r - insert the content of the register selected by following input char
")
]


#block(breakable: false)[
== Pickers
#Comment[
Navigation keys shown.
]
#Proc( "
Shift-<tab>, Ctrl-p, <Up> - previous entry
<tab>, Ctrl-n, <Down> - next entry
<Home> - to first entry
<End> - to last entry
Ctrl-u, <PageUp> - page up
Ctrl-d, <PageDown> - page down
<enter> - open selected
Alt-<enter> - open selected in the background without closing the picker
Ctrl-s - open horizontally
Ctrl-v - open vertically
Ctrl-t - toggle preview
Esc, Ctrl-c - close picker
")
]

#block(breakable: false)[
== Popups
#Comment[
Displays documentation for item under cursor.
]

#Proc( "
Ctrl-u - scroll up
Ctrl-d - scroll down
")
]

#block(breakable: false)[
== Completion Menu
#Comment[
Displays documentation for the selected completion item.
Any other keypresses result in the completion being accepted.
]
#Proc( "
Shift-Tab, Ctrl-p - previous entry
Tab, Ctrl-n - next entry
<enter> - close menu and accept completion
Ctrl-c - close menu and reject completion
")
]

#block(breakable: false)[
== Signature-help Popup
#Comment[
Displays the signature of the selected completion item.
]
#Proc( "
Alt-p - previous signature
Alt-n - next signature
")
]

// -------------------------------------------------------------------

#if do_index {
    if do_breaks {
        pagebreak()
    }
    [= Command Index]
    show_index()
}

#if do_toc{
    if do_breaks {
        pagebreak()
    }
    //  Simple TOC that uses existing column layout
    text(font: ft_toc, size: sz_toc, fill: colors.fg_color )[
        #outline()
    ]
}

// -------------------------------------------------------------------
/*  
    //  Three-column TOC layout, may make sense at top of sheet for reading on screen.
    //  Keep for later exploration.

    #pagebreak()
    #place(
      top + center,
      scope: "parent",
      float: true,
      clearance: 1em,   // space between TOC and body text below

      // layout() now sees full page width (minus margins)

      std.layout(size => context {
            let num-cols  = 3
            let col-gutter = 10pt

            let col-width = (size.width - col-gutter * (num-cols - 1)) / num-cols

            let toc-content = [
                #text(font: ft_toc, size: sz_toc, fill: colors.fg_color )[
                    #outline()
                ]
            ]

            let min-height = measure(
              block(width: col-width, toc-content)
            ).height / num-cols

            block(
              width: size.width,
              height: min-height,
              columns(num-cols, gutter: col-gutter, toc-content)
            )
        })
    )
*/

// -------------------------------------------------------------------

