#!/usr/bin/env bash

rm -fr site
git checkout master
make site-build 

git checkout gh-pages

shopt -s extglob
rm -fr !(site)
mv site/* ./
rmdir site

git add .
git commit -m "Labs update"
git status
git push origin gh-pages

git checkout master
