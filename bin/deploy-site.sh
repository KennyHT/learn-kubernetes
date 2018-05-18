#!/usr/bin/env bash

rm -fr site
git checkout master
make site-build 
git checkout gh-pages
rm -fr !(site)
mv site/* ./
mkdir site
git add .
git commit -m "Labs update"
git status
git push origin gh-pages
