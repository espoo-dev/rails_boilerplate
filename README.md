# install

1. build containers

   ```docker-compose build```

1. start containers in background

   ```docker-compose up -d```

1. connect to rails service

   ```
   docker exec -it rails bash
   bundle install
   rake db:setup
   rspec -> you can see coverage on "volume/blog-backend/coverage/index.html"
   railss
   ```

1. connect to vue service (in another bash)

   ```
   docker exec -it vue bash
   yarn
   yarn jest --coverage -> you can see coverage on "volume/blog-frontend/coverage/lcov-report/index.html"
   yarn serve
   ```

1. access 

   ``` http://localhost:8080/#/login ```
