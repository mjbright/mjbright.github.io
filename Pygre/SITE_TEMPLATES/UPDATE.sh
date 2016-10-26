#!/bin/bash

press() {
    echo "$*"
    echo "Press <return> to continue"
    read _DUMMY
    [ "$_DUMMY" = "q" ] && exit 0
    [ "$_DUMMY" = "Q" ] && exit 0
}

#set -x
cd /d/z/www/mjbright.github.io/Pygre/SITE_TEMPLATES
pwd
press "About to edit ./createIndex.py"
clear; /usr/bin/vi createIndex.py

chmod +x ./createIndex.py 
./createIndex.py 
ls -al -tr

press "diff op.html ../index.html"
diff op.html ../index.html

press "About to copy op.html to site index.html"
cp op.html ../index.html

git add ../index.html createIndex.py
git status

press "About to commit (all files included, including images?)"
git commit -m "Updated meetings" ../index.html createIndex.py 
#git add ../images/2016-Feb-23_UsingMongoDBAndPython.png 
#git commit -m "Updated meetings" ../index.html createIndex.py  ../images/2016-Feb-23_UsingMongoDBAndPython.png 

press "About to push"
git status
git push

