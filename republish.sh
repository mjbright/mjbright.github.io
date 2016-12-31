#!/bin/bash


press() {
    echo "$*"
    echo "Press <return> to continue"

    read _DUMMY
    [ "$_DUMMY" = "q" ] && exit 0
    [ "$_DUMMY" = "Q" ] && exit 0
}

GIT_SRC=~/z/www/mjbright.github.io/
cd $GIT_SRC/hugosite

press "Edit publications content under hugosite/content/publication/"

pwd
press "Regenerating site using hugo"
~/z/bin/lin64/hugo_0.18_linux_amd64/hugo_0.18_linux_amd64

press "Copying generated site from [$PWD]/public to $GIT_SRC/"
rsync -av public/ $GIT_SRC/ | grep -v /$

cd $GIT_SRC/

echo; echo "git status"
git status

press "About to perform 'git diff'"
git diff

press "GIT Add/Commit/Push changes"

TO_ADD=$(git diff | grep ^diff | sed -e 's/diff --git a\///' -e 's/ b\/.*//')
echo "git add $TO_ADD"
git add $TO_ADD

git commit -e

git push


