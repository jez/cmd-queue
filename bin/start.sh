#/usr/bin/env bash

if [ "$NODE_ENV" = "development" ] && which nodemon &> /dev/null ; then
  nodemon -e js,coffee --ignore public/ ./bin/start.js
else
  node ./bin/start.js
fi
