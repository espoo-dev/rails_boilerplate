# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

All commands run inside Docker containers:

```bash
# Setup (first time)
cp .env.example .env
docker compose build
docker compose up
docker compose exec web bundle install
docker compose exec web bin/rails db:setup

# Start development
bin/dev                                              # Start server on localhost:3000

# Run tests (note: -P flag needed to include pack specs)
docker compose exec web bundle exec bin/rspec -P ./*/**/*_spec.rb

# Run single test file
docker compose exec web bundle exec bin/rspec spec/requests/api/v1/users_request_spec.rb

# Lint (RuboCop with auto-fix + Reek)
docker compose exec web bundle exec bin/lint

# Security scan (Brakeman)
docker compose exec web bundle exec bin/scan

# Run both lint and security
docker compose exec web bundle exec bin/analyze

# Check modular architecture
docker compose exec web bundle exec bin/packwerk check
```

## Architecture Overview

Rails 7.1.3 API with Ruby 3.4.8, using Docker (PostgreSQL 15, Redis, Elasticsearch 8.10.2, Sidekiq).

### Key Patterns

**ServiceActor Pattern** - Business logic in `app/actors/`. Actors define typed `input`/`output`, use `fail!` for errors:
```ruby
class FetchSchools < Actor
  input :school_index_contract
  output :data
  def call
    self.data = fetch_schools
  end
end
```

**Dry::Validation Contracts** - Input validation in `app/contracts/`. Extend `ApplicationContract`, raise `InvalidContractError` on failure:
```ruby
UserContracts::Create.call(permitted_params(:email, :password))
```

**Pundit Authorization** - Policies in `app/policies/`. Controllers call `authorize(resource)` and include `after_action :verify_authorized`.

**API Structure** - Controllers inherit from `Api::V1::ApiController` which provides:
- JWT authentication via `devise-api` (`authenticate_devise_api_token!`)
- Standard error handling for `Pundit::NotAuthorizedError`, `ActiveRecord::RecordInvalid`, `InvalidContractError`
- `permitted_params(*keys)` helper for parameter extraction
- PaperTrail audit trail (`set_paper_trail_whodunnit`)

**Packwerk Modular Architecture** - Isolated modules in `packs/` directory (e.g., `demo_pack`, `oauth`). Each pack has its own controllers, actors, specs, and routes module.

### Directory Structure

- `app/actors/` - ServiceActor business logic
- `app/contracts/` - Dry::Validation input contracts
- `app/policies/` - Pundit authorization
- `app/chewy/` - Elasticsearch indices (Chewy)
- `app/sidekiq/` - Background jobs
- `app/graphql/` - GraphQL schema, types, mutations
- `packs/` - Packwerk modular packages

### Testing

RSpec with FactoryBot. Test helpers in `spec/support/`:
- `auth_headers_for(user)` - Generate Bearer token headers for authenticated requests
- `json_response` - Parse response body with indifferent access

Request spec pattern:
```ruby
let(:headers) { auth_headers_for(user) }
before { get "/api/v1/users", headers: }
it { expect(response).to have_http_status(:ok) }
```

### Web Interfaces

- API Docs (Swagger): http://localhost:3000/api-docs/index.html
- GraphQL IDE: http://localhost:3000/graphiql
- Sidekiq Dashboard: http://localhost:3000/sidekiq/
- Admin Dashboard: http://localhost:3000/admin

### Sidekiq Jobs

After creating new jobs, rebuild the sidekiq container:
```bash
docker compose stop
docker compose up --build
```

### Code Style

- Double quotes for strings
- Uses `frozen_string_literal: true` pragma
- RuboCop extensions: rubocop-rails, rubocop-rspec, rubocop-graphql, rubocop-performance
