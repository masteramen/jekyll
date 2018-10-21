#!/bin/sh
export JEKYLL_ENV=production 
cd ~/git/blog && git pull
cd ~/git/jekyll
bundle exec jekyll build --config ~/git/jekyll/_config.yml -s ~/git/jekyll  -d ~/git/site --inc 
cd ~/git/site && git add . 
cd ~/git/site &&  git commit -am "auto commit $(date)" && git push
