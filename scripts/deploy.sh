#!/bin/sh

curl https://cli-assets.heroku.com/install.sh | sh
heroku container:login
heroku git:remote -a $HEROKU_APP_NAME
heroku container:push --recursive
heroku container:release web --app=$HEROKU_APP_NAME
heroku run bundle exec rails db:migrate db:seed --app=$HEROKU_APP_NAME
