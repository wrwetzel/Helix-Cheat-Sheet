// ---------------------------------------------------------------------------------
//  Bills-Cheat-Sheet-Utils.typ - 
//  WRW 23-Apr-2025 - pulled this out of Bills-Helix-Cheat-Sheet.typ, converted
//      into template to #import into above file.
// ---------------------------------------------------------------------------------

//  Building:
//      typst compile <options> Bills-Helix-Cheat-Sheet.typ <ofile>

//          --input debug=false / true
//          --input pagesize=us-letter / a4 / poster / booklet    And any Typst-supported size
//          --input theme=light / dark
//          --input orientation=portrait / landscape
//          --input show-breaks=true / false            false for posters
//          --input show-index=true / false             false for poster, booklet
//          --input show-toc=false / true               New option, independent of 'poster'
//          --input col-width=60                        For adaptive testing, in em of ft_command bold
//          --input font-scale=1.0                      For adaptive testing
//          --input fit=false / true                    Also do computed for us-letter, a4, poster
//          --input width=0.0                           Set explicit page width, default none
//          --input height=0.0                          Set explicit page height, default none
//          --input mx=.5                               Set explicit page left & right margin
//          --input my=.5                               Set explicit page top & bottom margin
//          --input col_count=0                         Set explicit column count
//          --input no-binding=false                    true to suppress alternating margin widths

// ---------------------------------------------------------------------------------
//  Todo:
//      Think about dict structure for storing index so can sort on command and section number.
//      #arr.sorted(key: it => (it.cmd, it.section))
//      Maybe migrate to commands in external file with notation for basics/quick-reference, unlikely.
//      Why us-letter and ansi-a differ on column count with adaptive build? OK with column size of 60em.

/*  For 'booklet' if have to force to multiple of 4 pages

    // Force page count to multiple of 4
    #let pad-to-4(doc) = {
      doc
      while calc.rem(counter(page).final().at(0), 4) != 0 {
        pagebreak()
      }
    }

*/

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
        let L = page_layout.get()
        let sz_command = L.font-size
        let sz_command_def = L.font-size + 1pt
    }

    Width of M of 10pt font is around 6pt. "M" was measuring quotes, too.
*/

// =================================================================================
//  Global values
// ---------------------------------------------------------------------------------

#let default_column_width_em = 60       // Fixed width of columns, derrived empirically.

#let std_width = 8.5in                  // Used for 'poster' and 'booklet'
#let std_height = 11in

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
#let No_Binding_Flag =      if sys.inputs.at( "no-binding", default: "false") == "true" { true } else { false }

#let arg_column_width_em =  float( sys.inputs.at("col-width", default: default_column_width_em ))
#let arg_font_scale =       float( sys.inputs.at("font-scale", default: "1.0"))

//  Following are only applicable to custom size
//      arg_width > 0.0 and arg_height > 0.0 is indicator for custom size

#let arg_width =            float( sys.inputs.at("width", default: 0.0 ) )      
#let arg_height =           float( sys.inputs.at("height", default: 0.0 ) )
#let arg_mx =               float( sys.inputs.at("mx", default: .5 ) )
#let arg_my =               float( sys.inputs.at("my", default: .5 ) )
#let arg_col_count =        sys.inputs.at("col-count", default: 1)
#let ( custom_width, custom_height ) = (arg_width * 1in, arg_height * 1in)
#let ( custom_mx, custom_my ) = (arg_mx * 1in, arg_my * 1in)
#let custom_size = if arg_width > 0.0 and arg_height > 0.0 { true } else { false }

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

#let sz_toc = 7pt * arg_font_scale                          // Table of contents
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

//  WRW 17-Apr-2025 - set page size explicitly via 'pw', 'ph' for "poster", via 'paper' for all else.
//  Poster dimensions set here.
//  page.width, page.height do not change when 'flipped: true' for named sizes.
//  Keep explicit dimensions for portrait and landscape the same to be consistent with named sizes
//  as we later flip them for landscape.

#let get_page_params() = {

    if pagesize == "poster" {               //  17 h x 33 v, Portrait poster
        if orientation == "portrait" {        
            ( gutter: .25in,
              margin: (
                inside: .6in,
                outside: .6in,
                top: .6in,
                bottom: .6in,
              ),
              paper: none,
              flipped: false,
              column_count: 3,      // 4 put break in gutter but had an empty column
              pw: std_width * 2,
              ph: std_height * 3
            )

        } else {                            // 33 w x 17 h, Landscape poster
            ( gutter: .75in,                // .75in centers the gutter on the page break
              margin: (
                inside: .75in,
                outside: .75in,
                top: .75in,
                bottom: .75in,
              ),
              paper: none,
              column_count: 6,
              flipped: true,
              pw: std_width * 2,
              ph: std_height * 3
           )
        }

    } else if pagesize == "booklet" {        // WRW 24-Apr-2025 - move from exp to defined size
        ( gutter: .25in,
          margin: (
            inside: .4in,
            outside: .4in,
            top: .4in,
            bottom: .4in,
          ),
          paper: none,
          flipped: false,
          column_count: 1,                                                      
          pw: std_width/2,
          ph: std_height/2
        )

    } else if custom_size {
        let flipped = if orientation == "portrait" { false } else { true }
        let margin = if No_Binding_Flag {
         ( inside: custom_mx, outside: custom_mx, top: custom_my, bottom: custom_my )
        } else { 
          ( inside: custom_mx * 2, outside: custom_mx, top: custom_my, bottom: custom_my )
        }

        ( gutter: .25in,
          margin: margin,
          paper: none,
          column_count: arg_col_count,
          flipped: flipped,
          pw: custom_width,
          ph: custom_height,
        )

    } else {    // anything else including us-letter or a4
        let ( flipped, column_count ) = if orientation == "portrait" { ( false, 2 ) } else { ( true, 3 ) }
        let margin = if No_Binding_Flag { ( inside: .6in, outside: .6in, top: .6in, bottom: .6in, )
        } else {
          ( inside: .6in, outside: .3in, top: .6in, bottom: .6in, )
        }

        ( gutter: .25in,
          margin: margin,
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
    if pagesize == "poster" or pagesize == "booklet" or custom_size {    // uses 'width:' and 'height:' to specify size
        (
        columns: pp.column_count,
        margin: pp.margin,
        width: pp.pw,
        height: pp.ph,
        flipped: pp.flipped,
        fill: colors.bg_color,
        )

    } else {                        // uses 'paper:' to specify size
        (
        columns: pp.column_count,
        margin: pp.margin,
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
    let usable    = logical_page_width - (margin.inside + margin.outside)     // WRW 22-Apr-2026
    let col_cnt   = calc.max(1, calc.floor(usable / col-width))
    let gutter    = calc.max( 0.25in, col-width * 0.1)

    (cols: col_cnt, gutter: gutter, margin: margin, source: "Computed" )
}

// ==========================================================================
//  *** Global layout. ***

//  I tried moving the "#show: rest context{...}" below into a function but stumbled 
//      on scope and context issues. Keep it in global scope.

//  Hand-tuned parameters for us-letter, a4, 'poster', and 'booklet'. Computed for all other sizes by calc-layout()
//  Fit_Flag set in Build-Adaptive.py to force computed for all including us-letter, a4, and poster.

// --------------------------------------------------------------------------
//  Can't include "..pa" in "set page( columns: L.cols )" below because 'columns:' appears in both.
//  set page() overrides columns with computed value for adaptive use.

#let colors = get_colors()
#let pp = get_page_params()
#let pa = get_pa( pp, colors )
#let page_layout = state("page_layout", (cols: 0, gutter: 0pt, font-size: 10pt))  //  Declare state with a default

#let template( doc ) = {
    set page( ..pa )
    // Default foreground text color, font, size for whole document including title and headings.
    set text( fill: colors.fg_color, font: ft_heading, size: sz_heading )      // heading scale from this
    set heading(numbering: "1.1")
    
    show: rest => context {
        let column_width_em = measure( text( font: ft_command, size: sz_command, weight: "bold" )[M]).width * arg_column_width_em
    
        //  Keep hand-tuned dimensions for common sizes for page fit, compute all the rest.
    
        let L = if not Fit_Flag and ( custom_size or pagesize == "us-letter" or pagesize == "a4" or pagesize == "poster" or pagesize == "booklet" ) {
            ( cols: pp.column_count, gutter: pp.gutter, margin: pp.margin, source: "Specified" )
    
        } else {
            calc-layout( col-width: column_width_em, margin: pp.margin )        // Computed
        }
    
        page_layout.update(L)                        // Save it in state
    
        set page( columns: L.cols )             // Override columns with value computed in context for adaptive.

        // ---------------------------------------------------------
        //  Page numbering just for testing imposition for booklet. Keep it, I like it.
        set page(
            footer-descent: 4pt,
            footer: context {
                if calc.odd(counter(page).get().first()) {
                    align(right)[#counter(page).display()]
                } else {
                    align(left)[#counter(page).display()]
                }
            }
        )
        // ---------------------------------------------------------

        set columns( gutter: L.gutter )
        rest
    }
    doc
}

// #set text( fill: colors.fg_color, font: ft_heading, size: sz_heading )      // heading scale from this
// #set heading(numbering: "1.1")

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
        let L = page_layout.get()
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

                    // ----------------------------------
                    // Command and Definition

                    if parts.len() >= 2 {
                            //  WRW 26-Apr-2026 - Moved this inside >=2 parts condition
                            let t = measure( text( font: ft_command, size: sz_command, weight: "bold" )[#cmd]).width
                            t += measure( text(font: ft_command, size: sz_command )[#sym.dash.en]).width
                            max_cmd_width = calc.max( max_cmd_width, t )

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
        let computed_col_width = ( logical_page_width - ( (L.cols - 1) * L.gutter + L.margin.inside + L.margin.outside ) ) / L.cols

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

// ---------------------------------------------------------------------------------
