# Requirements
- Docker
- Docker-compose

# Getting Started
- docker-compose build
- docker-compose run web bin/rails db:setup
- docker-compose up
- visit http://localhost:3000/

# Run tests
- docker-compose exec web bundle exec rspec
- open coverage/index.html (Check coverage report)

# Check lint
- docker-compose exec web bundle exec rubocop -A
- docker-compose exec web bundle exec reek

# Check Security Vulnerabilities
- docker-compose exec web bundle exec brakeman

# API Doc Swagger
- localhost:3000/api-docs/index.html
