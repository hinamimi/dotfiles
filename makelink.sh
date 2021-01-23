#!/usr/bin/sh

for FILE in `ls -AF | grep -E '^\.' | grep -v .git/`; do
    rm -f ~/${FILE}
    ln -s ~/dotfiles/${FILE} ~/${FILE}
done
