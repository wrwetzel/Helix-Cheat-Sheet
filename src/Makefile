.RECIPEPREFIX = +
# ---------------------------------------------------------------------------
#   Makefile
# ---------------------------------------------------------------------------

SERVER-DEST  = wrwetzel.com:www/Helix-Cheat-Sheet

# ---------------------------------------------------------------------------

Source = Bills-Helix-Cheat-Sheet.typ 
ORoot = Bills-Helix-Cheat-Sheet

one:          
+ typst compile --input orientation=portrait --input theme=dark $(Source) Test.pdf

poster:
+ typst compile --input pagesize=poster --input orientation=landscape --input theme=dark $(Source) Test-poster.pdf

split:
+ pdfposter -m 11x8.5in -p 33x17in Test-poster.pdf Test-split.pdf

all:          
+ Build.fish

# -------------------------------------------------

