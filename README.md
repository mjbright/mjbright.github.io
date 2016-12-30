mjbright.github.io
==================

Web sites/presentations.

Updating the site
==================

The script republish.sh attempts to auto-update the site.

Basically to update content, modify the content markdown files under

    hugosite/content/..../*.md

Then from hugosite directory

    hugo

to regenerate site (locally)

    hugo server

to view the current rendered site

Then update the repo:

    cd ~/z/www/mjbright.github.io/
    cd hugosite

    rsync -av public/ ~/z/www/mjbright.github.io/

    git status
    git diff

    git add ....
    git commit
    git push

