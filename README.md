# Requirements
- Docker
- Docker-compose

# Getting Started
- docker compose build
- docker compose run web bin/rails db:setup
- docker compose up
- visit http://localhost:3000/

# Check lint
- docker compose exec web bundle exec rubocop -A
- docker compose exec web bundle exec reek
# Check Security Vulnerabilities
- docker compose run web bundle exec brakeman
