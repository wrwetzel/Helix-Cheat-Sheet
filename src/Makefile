.RECIPEPREFIX = +
# ---------------------------------------------------------------------------
#   Makefile
# ---------------------------------------------------------------------------

SERVER-DEST  = wrwetzel.com:www/Helix-Cheat-Sheet

#   one, poster, split - for development test purposes
#   readme - to make content for README.md

# ---------------------------------------------------------------------------

Source = Bills-Helix-Cheat-Sheet.typ
ORoot =  Bills-Helix-Cheat-Sheet

all: one a4 poster split readme dist dist-adaptive

one:
+ typst compile --input orientation=landscape --input theme=dark $(Source) Test.pdf

a4:
+ typst compile --input pagesize=a4 --input orientation=landscape --input theme=dark $(Source) Test-a4.pdf

poster:
+ typst compile --input debug=false --input pagesize=poster --input orientation=landscape --input theme=dark --input show-breaks=false --input show-index=false $(Source) Test-poster.pdf

split:
+ pdfposter -m 11x8.5in -p 33x17in Test-poster.pdf Test-split.pdf

readme:
+ magick Test-poster.pdf -resize 35% -density 300 ../Images/poster.jpg

dist:
+ Build-Fixed.fish

dist-adaptive:
+ Build-Adaptive.py

# -------------------------------------------------

