#!/bin/sh
export JEKYLL_ENV=production 
cd /blog && git pull
bundle exec jekyll build --config /site/_config.yml -s /site  -d /blog --inc 
cd /blog && git add . 
cd /blog &&  git commit -am "auto commit $(date)" && git push
