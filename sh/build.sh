#!/bin/sh
export JEKYLL_ENV=production 
bundle exec jekyll build --config /site/_config.yml -s /site  -d /blog 
cd /blog && git add . &&  git commit -am 'auto commit $(date)' && git push
