#!/bin/bash

########################################
# Config:

#
# NOTE: Default CV location is $SRC_FILE
#   currently:
#        ~/z/www/mjbright.github.io/static/docs/src/CV.xlsx
#

URL=http://mjbright.github.io/static/docs/cv.pdf

RESUME_DIR=~/src/git/GIT_mjbright/resume_42

TMP_RESULT_DIR="$RESUME_DIR/result"
TMP_PDF_FILE="$TMP_RESULT_DIR/cv.pdf"

TARGET_DIR=~/z/www/mjbright.github.io/static/docs

SRC_FILE=$TARGET_DIR/src/CV.xlsx 
TARGET_PDF_FILE="$TARGET_DIR/cv.pdf"

########################################
# Functions:

press() {
    echo $*
    echo "Press <return> to continue"
    read _DUMMY
    [ "$_DUMMY" == "q" ] && exit 0
    [ "$_DUMMY" == "Q" ] && exit 0
}

die() {
    echo "$0: die - $*" >&2
    exit 1
}

########################################
# Main:

echo; echo "Using source file $SRC_FILE"

[ ! -d $RESUME_DIR ] && die "No such resume dir <$RESUME_DIR>"

[ ! -d $TARGET_DIR ] && die "No such target dir <$TARGET_DIR>"

[ ! -f $SRC_FILE ] && die "No such resume file <$SRC_FILE>"

[ ! -d $TMP_RESULT_DIR ] && die "No such temp result dir <$TMP_RESULT_DIR>"

cd $RESUME_DIR

press "Build new CV from <$SRC_FILE>"

echo;
echo "[pwd=$PWD]"
./RUN.sh $SRC_FILE
[ $? -ne 0 ] && die "Failed to invoke docker"

ls -al $TMP_PDF_FILE
[ ! -f $TMP_PDF_FILE ] && die "No resume PDF file generated <$TMP_PDF_FILE>"

cp -a $TMP_PDF_FILE $TARGET_PDF_FILE

[ ! -f $TARGET_PDF_FILE ] && die "No such resume PDF file <$TARGET_PDF_FILE>"

echo "Generated new PDF from <$SRC_FILE>"
ls -altr $SRC_FILE $TARGET_PDF_FILE
#find $TARGET_PDF_FILE -newer $SRC_FILE && die "[$PWD] Failed to update target PDF"
find $TARGET_PDF_FILE -newer $SRC_FILE | grep -q $TARGET_PDF_FILE || die "[$PWD] Failed to update target PDF"

cd $TARGET_DIR

echo;
echo "[pwd=$PWD]"
press "About to push new PDF <$TARGET_PDF_FILE> file to $URL"

PDF_URL=https://mjbright.github.io/static/docs/cv.pdf

# Create unique URL to work around server caching:
URL=${PDF_URL}?$(date +%s)

CKSUM_INITIAL=$(wget --no-cache -O - $URL 2>/dev/null | cksum)

ls -al $TMP_PDF_FILE $SRC_FILE $TARGET_PDF_FILE
git add $SRC_FILE $TARGET_PDF_FILE
git commit
git push

echo "CV updated at URL <$URL> (after delay ~ 1 min)"

cksum $TMP_PDF_FILE $TARGET_PDF_FILE

echo "$(date): $CKSUM_INITIAL"
while [ 1 ]; do
    URL=${PDF_URL}?$(date +%s)
    CKSUM=$(wget --no-cache -O - $URL 2>/dev/null | cksum)
    [ "$CKSUM" != "$CKSUM_INITIAL" ] && break

    echo "$(date): $CKSUM"
    sleep 10
done

echo "$(date): $CKSUM"
echo "Online"

#die "OK"
 #cd ~/z/www/mjbright.github.io/static/docs/src/CV.xlsx 
 

