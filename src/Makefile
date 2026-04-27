.RECIPEPREFIX = +
# ---------------------------------------------------------------------------
#   Makefile
# ---------------------------------------------------------------------------

SERVER-DEST  = wrwetzel.com:www/Helix-Cheat-Sheet

#   all - tests and distribution
#   tests - for development test purposes
#   readme - to make content for README.md
#   exp - exploratory code

# ---------------------------------------------------------------------------

Source = Bills-Helix-Cheat-Sheet.typ
QSource = Bills-Helix-Quick-Start.typ
ORoot =  Bills-Helix-Cheat-Sheet

all: tests readme dist dist-auto-fit

tests: one quick booklet a4 poster split

exp:
+ typst compile --input mx=.4 --input my=.4 --input no-binding=true --input font-scale=1.0 --input width=4.25 --input height=5.5 --input show-index=false $(Source) Exp.pdf
+ booklet-impose.py Exp.pdf Exp-print.pdf

one:
+ typst compile --input orientation=landscape --input theme=dark $(Source) --input show-toc=true Test-letter.pdf

quick:
+ typst compile --input orientation=landscape --input theme=dark $(QSource) Test-quick-letter.pdf

booklet:
+ typst compile --input debug=false --input pagesize=booklet --input show-index=false --input show-toc=true $(Source) Test-booklet.pdf
+ booklet-impose.py Test-booklet.pdf Test-booklet-print.pdf

a4:
+ typst compile --input pagesize=a4 --input orientation=landscape --input theme=dark $(Source) Test-a4.pdf

poster:
+ typst compile --input debug=false --input pagesize=poster --input orientation=landscape --input theme=dark --input show-breaks=false --input show-index=false $(Source) Test-poster.pdf

split:
+ pdfposter -m 11x8.5in -p 33x17in Test-poster.pdf Test-poster-print.pdf

readme:
+ magick Test-poster.pdf -resize 35% -density 300 ../Images/poster.jpg

dist:
+ Build-Fixed.fish

dist-auto-fit:
+ Build-Auto-Fit.py --sample-poster

# -------------------------------------------------

