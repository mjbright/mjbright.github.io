
# -w: watch mode
# -r: relative links
#landslide -w -r -c Slides.md --theme=theme/impress/

#IFILE=./Slides.md
IFILE=./slides.cfg
REF_IFILE=./Slides.md
OFILE=presentation.html

[ ! -z "$1" ] && [ -f "$1" ] && IFILE="$1"
[ ! -z "$2" ] && [ -f "$2" ] && OFILE="$2"

touch $REF_IFILE

while true; do
    #find ./Slides.md -newer presentation.html -exec landslide -r -c Slides.md --theme=theme/impress/ {} \;
    if [ `find $REF_IFILE  -newer $OFILE | wc -l` != "0" ];then
        echo "IFILE=$IFILE"
        #set -x; landslide -r -c $IFILE; set +x;
        set -x; landslide $IFILE; set +x;
    fi
    sleep 1
done

