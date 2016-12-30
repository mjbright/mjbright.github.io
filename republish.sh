#!/bin/bash

press() {
    echo "$*"
    echo "Press <return> to continue"

    read _DUMMY
    [ "$_DUMMY" = "q" ] && exit 0
    [ "$_DUMMY" = "Q" ] && exit 0
}

WWW_MJB=~/z/www/mjbright.github.io/hugosite
cd $WWW_MJB

pwd
press "Regenerating site using hugo"
~/z/bin/lin64/hugo_0.18_linux_amd64/hugo_0.18_linux_amd64

press "Copying generated site from [$PWD]/public to $WWW_MJB/"
rsync -av public/ $WWW_MJB/ | grep -v /$

git status
git diff

