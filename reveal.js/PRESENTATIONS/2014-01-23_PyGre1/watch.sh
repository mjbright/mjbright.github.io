#!/bin/sh

while [ 1 ]
do
    sleep 1

    #find . -name '*.txt' -newer intro.txt.tmp -exec ./build.sh {} \;
    #newer=`find . -name '*.txt' -newer intro.txt.tmp -exec ./build.sh {} \;`

    newer=`find . -name '*.txt' -newer intro.txt.tmp`

    if [ ! -z "$newer" ];then
        echo "BUILDING $newer"
        ./build.sh $newer
        ls -altr *.html
    else
        echo -n "."
    fi

done

