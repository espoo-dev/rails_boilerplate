# install

docker-compose build

docker-compose up -d

docker-compose exec rails_server rake db:create db:migrate db:seed

docker-compose exec rails_server rspec
