#! /bin/sh
# 
# First, create the basic version
pdflatex $1
if `grep 'undefined references' tmp.log >/dev/null 2>&1` ; then 
    :
else
    pdflatex $1
fi
# Now, create the various print versions
sed 's/^\\documentclass\[10pt\]{beamer}/\\documentclass\[handout,10pt\]{beamer}/' <$1.tex >tmp.tex
pdflatex -jobname $1.print tmp.tex
# A few lectures make use of equation numbers and references in which case
# a second pdflatex step is necessary 
if `grep 'undefined references' tmp.log >/dev/null 2>&1` ; then 
    :
else
    pdflatex -jobname $1.print tmp.tex
fi
pdfnup --nup 1x2 $1.print.pdf
pdfnup --nup 2x2 --landscape $1.print.pdf
./cleanup.sh
rm -f tmp.tex
