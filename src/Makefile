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

one:          
+ typst compile --input orientation=portrait --input theme=dark $(Source) Test.pdf

poster:
+ typst compile --input pagesize=poster --input orientation=landscape --input theme=dark $(Source) Test-poster.pdf

split:
+ pdfposter -m 11x8.5in -p 33x17in Test-poster.pdf Test-split.pdf

readme:
+ magick Test-poster.pdf -resize 35% -density 300 ../Images/poster.jpg

all:          
+ Build.fish

# -------------------------------------------------

