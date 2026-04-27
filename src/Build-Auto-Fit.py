#!/usr/bin/env python3
# -------------------------------------------------------------------------------
#   Build-Adaptive.py - iteratively find a font size for content to fit on
#       a given page count, default 1. Leave result in Trial-poster.pdf for now.

#   US Engineering drawing sizes

#       ANSI A (8.5 x 11 in): #set page(width: 8.5in, height: 11in)
#       ANSI B (11 x 17 in): #set page(width: 11in, height: 17in)
#       ANSI C (17 x 22 in): #set page(width: 17in, height: 22in)
#       ANSI D (22 x 34 in): #set page(width: 22in, height: 34in)
#       ANSI E (34 x 44 in): #set page(width: 34in, height: 44in)

# -------------------------------------------------------------------------------

import os
import sys
import subprocess
from pypdf import PdfReader

# -------------------------------------------------------------------------------

ifile = "Bills-Helix-Cheat-Sheet.typ"
odir = "../dist-auto-fit/"
base = "Bills-Helix-Cheat-Sheet"

# -------------------------------------------------------------------------------
#   For dot-notation references

class DotDict(dict):
    def __getattr__(self, key):
        return self.get(key)
    __setattr__ = dict.__setitem__
    __delattr__ = dict.__delitem__

# -------------------------------------------------------------------------------

def compile( params, ofile, col_width_em, font_scale):
    print( f"Trying: scale: {font_scale:1.4f},", end = '' )

    result = subprocess.run([
        "typst", "compile",
        f"--input", f"col-width={col_width_em}",
        f"--input", f"theme={params.theme}",
        f"--input", f"pagesize={params.pagesize}",
        f"--input", f"orientation={params.orientation}",
        f"--input", f"show-breaks={params.breaks}",
        f"--input", f"show-index={params.index}",
        f"--input", f"show-toc={params.toc}",
        f"--input", f"font-scale={font_scale}",
        f"--input", f"fit={params.fit}",
        f"--input", f"no-binding={params.no_binding}",
        f"--input", f"debug={params.debug}",
        ifile, ofile
    ], capture_output=True)

    if result.returncode:
        print( "\nERROR: typst failed" )
        print( result.stderr.decode( 'utf-8' ))
        return None

    else:
        reader = PdfReader( ofile )
        page_count = len(reader.pages)
        return page_count

# ---------------------------------------------------------------------------------
#   Modify font size. The low end is absurdly small just to prove function, not actually usable.

def build_one( params ):
    print( f"Building count: {params.count}, pagesize: {params.pagesize}, orientation: {params.orientation}, theme: {params.theme}, breaks: {params.breaks}, index: {params.index}, toc: {params.toc}" )

    scale_lo, scale_hi = .1, 2
    col_width_em = 60                        # col width in em. 1em is significant smaller than point size.
    good_scale_mid = 1
    tofile = f"/tmp/trial.pdf"

    # pass_cnt = 1
    while scale_hi - scale_lo  > 0.05:       # Stop when change reaches small limit of .05
        # tofile = f"/tmp/trial-{pass_cnt}.pdf"  # If want to look at all intermediate results.
        # pass_cnt += 1
        scale_mid = (scale_lo + scale_hi) / 2
        pages = compile( params, tofile, col_width_em, scale_mid)
        print( f" yielded {pages} pages" )
        if pages == None:
            return
        if pages <= params.count :              # fits on count pages
            good_scale_mid = scale_mid          # Save last one that fit on one page
            scale_lo = scale_mid
        else:
            scale_hi = scale_mid

    os.unlink( tofile )                         # Remove our temp file

    #   Compile again with last good scale

    ofile = f"{odir}/{base}_Fit_{params.count}_{params.pagesize}_{params.orientation}_{params.theme}.pdf"
    pages = compile( params, ofile, col_width_em, good_scale_mid )
    print( f" yielded {pages} pages" )
    print( f"Compiled {pages} pages in: {ofile}" )
    
# ---------------------------------------------------------------------------------

def do_sample_poster():
    #   Setting 1 page poster
    size_list = [ "ansi-a", "us-letter", "poster" ]       # for testing
    size_list = [ "poster", "us-letter", "us-legal", "a1", "a2", "a3", "a4", "ansi-a", "ansi-b", "ansi-c", "ansi-d", "ansi-e" ]

    for pagesize in size_list:
        params = DotDict({
            'pagesize': pagesize,
            'orientation': 'landscape',
            'breaks' : 'false',
            'index' : 'false',
            'toc' : 'false',
            'theme': 'dark',
            'count': 1,
            'fit' : 'true',         # force computed for 'poster', 'us-letter', 'a4'
            'no_binding' : 'true',
            'debug' : 'false',
        })

        build_one( params )
    
# --------------------------------------------------------------
#   Setting multiple pages - unsure if any use of this.
#       Probably best to let the page count go where it may for most applications
#       and not constrain it other than to 1 for posters. Keep nevertheless.
    
def do_sample_multi():

    for count in range( 1, 13 ):
        params = DotDict({
            'pagesize': "us-letter",
            'orientation': 'landscape',
            'breaks' : 'true',
            'index' : 'false',
            'toc' : 'false',
            'theme': 'dark',
            'count': count,
            'fit' : 'true',         # force computed for 'poster', 'us-letter', 'a4'
            'no_binding' : 'true',
            'debug' : 'false',
        })

        build_one( params )

# ---------------------------------------------------------------------------------

def do_one_poster( pagesize ):

    params = DotDict({
        'pagesize': pagesize,
        'orientation': 'landscape',
        'breaks' : 'false',
        'index' : 'false',
        'toc' : 'false',
        'theme': 'dark',
        'count': 1,
        'fit' : 'false',
        'debug' : 'false',
    })

    build_one( params )

# ---------------------------------------------------------------------------------

def do_one_multi( pagesize, count ):

    params = DotDict({
        'pagesize': pagesize,
        'orientation': 'landscape',
        'breaks' : 'false',
        'index' : 'false',
        'toc' : 'false',
        'theme': 'dark',
        'count': count,
        'fit' : 'false',
        'debug' : 'false',
    })

    build_one( params )

# ---------------------------------------------------------------------------------
#   For an error with undefined pagesize to get list of all supported.

def do_show_sizes():
    tofile = f"/tmp/trial.pdf"      # Never written, nothing to unlink()

    result = subprocess.run([
        "typst", "compile",
        f"--input", f"pagesize=bogus",
        ifile, tofile
    ], capture_output=True)

    if result.returncode:
        t = result.stderr.decode( 'utf-8' ).split('\n')
        t = t[0].replace( "error: expected", "" )
        print( t )

# ---------------------------------------------------------------------------------

if __name__ == "__main__":
    me = sys.argv.pop(0)             # Remove command name
    ok = False
    while len( sys.argv ):
        arg = sys.argv.pop(0)             # Remove command name

        if arg == "--odir":
            odir = sys.argv.pop(0)
            ok = True

        elif arg == "--poster":
            do_one_poster( sys.argv.pop(0) )
            ok = True

        elif arg == "--multi":
            do_one_multi( sys.argv.pop(0), int(sys.argv.pop(0) ))
            ok = True

        elif arg == "--sample-poster":
            do_sample_poster()
            ok = True

        elif arg == "--sample-multi":
            do_sample_multi()
            ok = True

        elif arg == "--show-sizes":
            do_show_sizes()
            ok = True

    if not ok:
        usage = f"{me}: --odir <odir> --poster <size> --multi <size> <count> --sample-poster --sample-multi --show-sizes"
        print( usage )
        sys.exit(1)

# ---------------------------------------------------------------------------------
