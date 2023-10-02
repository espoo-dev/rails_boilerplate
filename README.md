## Requirements
- Docker
- Docker-compose

## Getting Started
- docker compose build
- docker compose run web bundle install
- docker compose run web bin/rails db:setup
- docker compose up
- visit http://localhost:3000/

## Run tests
- docker compose exec web bundle exec bin/rspec
- open coverage/index.html (Check coverage report)

## Check lint
- docker compose exec web bundle exec bin/lint

## Check Security Vulnerabilities
- docker compose exec web bundle exec bin/scan

## API Doc Swagger
- http://localhost:3000/api-docs/index.html

- docker compose run web bundle install

## Sidekiq

- http://localhost:3000/sidekiq/

Observation: Every time that a new job is created, the server should be stopped and sidekiq image needs to be re-build, to perform that run the followed commands:

- docker compose stop
- docker compose up --build
