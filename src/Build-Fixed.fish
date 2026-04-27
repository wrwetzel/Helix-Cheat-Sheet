#!/usr/bin/fish
# ----------------------------------------------------------------------------
#   Build-Fixed.fish - WRW-10-Apr-2026
#   Build permutations of orientation, size, and theme options
#   Used default value of fit flag, 'false', for built-in parameters for us-letter, a4, poster
# ----------------------------------------------------------------------------

set Source Bills-Helix-Cheat-Sheet.typ
set Opath ../dist
set Obase $Opath/(path basename -E $Source)
set orientations portrait landscape
set sizes us-letter a4
set themes light dark
set debug false

# ------------------------------------------------------------------------
#   Build permutations

for orientation in $orientations
    for size in $sizes
        for theme in $themes
            echo $theme-$size-$orientation
            set Ofile {$Obase}_{$size}_{$orientation}_{$theme}.pdf
            typst compile --input debug=$debug --input pagesize=$size --input theme=$theme --input orientation=$orientation $Source $Ofile &
            end
        end
    end

# ------------------------------------------------------------------------
#   Build posters

for theme in $themes
    set orientation portrait
    set size poster
    echo $theme-$size-$orientation
    set opts -m 8.5x11in -p 17x33in
    set Ofile {$Obase}_{$size}_{$orientation}_{$theme}.pdf
    set OSplit $Opath/(path basename -E $Ofile)-split.pdf
    typst compile --input debug=$debug --input show-breaks=false --input show-index=false --input pagesize=$size --input theme=$theme --input orientation=$orientation $Source $Ofile & \
        wait $last_pid && pdfposter $opts $Ofile $OSplit &

    set orientation landscape
    set size poster
    echo $theme-$size-$orientation
    set opts -m 11x8.5in -p 33x17in
    set Ofile {$Obase}_{$size}_{$orientation}_{$theme}.pdf
    set OSplit $Opath/(path basename -E $Ofile)-split.pdf
    typst compile --input debug=$debug --input show-breaks=false --input show-index=false --input pagesize=$size --input theme=$theme --input orientation=$orientation $Source $Ofile & \
        wait $last_pid && pdfposter $opts $Ofile $OSplit &
    end

# ------------------------------------------------------------------------
#   Build booklet, portrait only but label with orientation for consistency

for theme in $themes
    set orientation portrait
    set size booklet
    echo $theme-$size-$orientation
    set Ofile {$Obase}_{$size}_{$orientation}_{$theme}.pdf
    set OPocket $Opath/(path basename -E $Ofile)-booklet.pdf
    typst compile --input debug=$debug --input show-breaks=false --input show-index=false --input pagesize=$size --input theme=$theme --input orientation=$orientation $Source $Ofile & \
        wait $last_pid && booklet-impose.py $Ofile $OPocket
    end

# ------------------------------------------------------------------------

wait

# ------------------------------------------------------------------------
