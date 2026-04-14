#!/usr/bin/fish
# ----------------------------------------------------------------------------
#   Build.fish - WRW-10-Apr-2026
#   Build all permutations of cheat sheet options
# ----------------------------------------------------------------------------

set Source Bills-Helix-Cheat-Sheet.typ
set Opath ../dist
set Obase $Opath/(path basename -E $Source)
set orientations portrait landscape
set sizes us-letter a4
set themes light dark

for orientation in $orientations
    for size in $sizes
        for theme in $themes
            echo $theme-$size-$orientation
            set Ofile $Obase-$size-$orientation-$theme.pdf
            typst compile --input pagesize=$size --input theme=$theme --input orientation=$orientation $Source $Ofile &
            end
        end
    end

for theme in $themes
    set orientation portrait
    set size poster
    echo $theme-$size-$orientation
    set opts -m 8.5x11in -p 17x33in
    set Ofile $Obase-$size-$orientation-$theme.pdf
    set OSplit $Opath/(path basename -E $Ofile)-split.pdf
    typst compile --input pagesize=$size --input theme=$theme --input orientation=$orientation $Source $Ofile & \
        wait $last_pid && pdfposter $opts $Ofile $OSplit &

    set orientation landscape
    set size poster
    echo $theme-$size-$orientation
    set opts -m 11x8.5in -p 33x17in
    set Ofile $Obase-$size-$orientation-$theme.pdf
    set OSplit $Opath/(path basename -E $Ofile)-split.pdf
    typst compile --input pagesize=$size --input theme=$theme --input orientation=$orientation $Source $Ofile & \
        wait $last_pid && pdfposter $opts $Ofile $OSplit &

    end
wait

