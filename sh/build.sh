#!/bin/sh
export JEKYLL_ENV=production 
jekyll build --config /site/_config.yml -s /site  -d /blog 
cd /blog && git commit -am 'auto commit $(date) && git push
