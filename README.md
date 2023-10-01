## Requirements
- Docker
- Docker-compose

## Getting Started
- docker compose build
- docker compose run web bin/rails db:setup
- docker compose up
- visit http://localhost:3000/

## Run tests
- docker compose exec -e RAILS_ENV=test web bundle exec rspec
- open coverage/index.html (Check coverage report)

## Check lint
- docker compose exec web bundle exec bin/lint

## Check Security Vulnerabilities
- docker compose exec web bundle exec bin/scan

## API Doc Swagger
- localhost:3000/api-docs/index.html

## Sidekiq

Observation: Every time that a new job is created, the server should be stopped and sidekiq image needs to be re-build, to perform that run the followed commands:

- docker compose stop
- docker compose up --build
