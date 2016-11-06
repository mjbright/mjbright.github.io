
IPFILE="$1"
[ -z "$IPFILE" ] && IPFILE="habits.txt"
OPFILE=${IPFILE%.txt}.html

##----------------------------------------

# Select theme from values below:
REVEALJS_THEME="moon"
REVEALJS_THEME="blood" # gray ?!
REVEALJS_THEME="beige"
REVEALJS_THEME="night"
REVEALJS_THEME="serif"
REVEALJS_THEME="sky"
REVEALJS_THEME="solarized"
REVEALJS_THEME="simple"
REVEALJS_THEME="default"

REVEALJS="-t revealjs -s -V theme=$REVEALJS_THEME -V revealjs-url=../.."
PRINT="-t html"

# ll .. /../css/theme/
#-rw-r--r--  1 mjbright mkgroup 4967 Dec 30 12:55 beige.css
#-rw-r--r--  1 mjbright mkgroup 5193 Dec 30 12:55 blood.css
#-rw-r--r--  1 mjbright mkgroup 4992 Dec 30 12:55 default.css
#-rw-r--r--  1 mjbright mkgroup 4261 Dec 30 12:55 moon.css
#-rw-r--r--  1 mjbright mkgroup 3796 Dec 30 12:55 night.css
#-rw-r--r--  1 mjbright mkgroup 1734 Dec 30 12:55 README.md
#-rw-r--r--  1 mjbright mkgroup 3869 Dec 30 12:55 serif.css
#-rw-r--r--  1 mjbright mkgroup 4001 Dec 30 12:55 simple.css
#-rw-r--r--  1 mjbright mkgroup 4410 Dec 30 12:55 sky.css
#-rw-r--r--  1 mjbright mkgroup 4262 Dec 30 12:55 solarized.css
#drwxr-xr-x+ 1 mjbright mkgroup    0 Dec 30 12:55 source
#drwxr-xr-x+ 1 mjbright mkgroup    0 Dec 30 12:55 template

##----------------------------------------

getPandoc() {
    PANDOC=`which pandoc 2>/dev/null`
    [ ! -z "$PANDOC" ] && [ -x "$PANDOC" ] && return 0
    #echo "PANDOC='$PANDOC'"

    PANDOC="/c/Users/mjbright/AppData/Local/Pandoc/pandoc.exe"
    if [ -z "$PANDOC" ];then
       echo "PANDOC is empty [=$PANDOC]"
    #else
    #   echo "PANDOC is NOT empty [=$PANDOC]"
    fi
    if [ ! -f ${PANDOC} ];then
       echo "PANDOC is not present [=$PANDOC]"
    fi
    if [ ! -f ${PANDOC%.exe} ];then
       echo "PANDOC is not present [=$PANDOC]"
    fi
    #echo PANDOC="$PANDOC"
    #if [ ! -x ${PANDOC%.exe} ];then
    #   echo "PANDOC is non-exec [=$PANDOC]"
    #fi

    [ ! -z "$PANDOC" ] && [ -f "$PANDOC" ] && return 0

    return 1
}

PROG=$0
die() {
    echo "$PROG: die - $*" >&2
    exit 1
}

removeEndText() {
    awk '
      /^;;;END$/ { exit; };
      //         { print $0; };
    ' < $IPFILE | \
        grep -v "^;;;" > ${IPFILE}.tmp

    IPFILE=${IPFILE}.tmp
    #[ -s ${IPFILE}.tmp ] && mv ${IPFILE}.tmp $IPFILE
}

enableRefresh() {
    awk '
      /<title>/  { print "  <meta http-equiv=\"refresh\" content=\"1\">"; };
      //         { print $0; };
    ' < $OPFILE > ${OPFILE}.tmp
    mv ${OPFILE}.tmp ${OPFILE}
}

##----------------------------------------

getPandoc || die "Failed to find PANDOC executeable"

removeEndText

$PANDOC $REVEALJS $IPFILE -o $OPFILE
$PANDOC $PRINT    $IPFILE -o ${OPFILE}.print.html

#enableRefresh

#/c/Users/mjbright/AppData/Local/Pandoc/pandoc.exe -t revealjs -s habits.txt -o habits.html

#sed -i.bak -e 's/reveal.js\//..\/..\//g' habits.html
#grep -v "^<p>;" habits.html > habits.html.tmp
#[ -s habits.html.tmp ] && mv habits.html.tmp habits.html


#cmd /c explorer .
