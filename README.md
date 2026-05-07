# Rails Boilerplate

Full-stack monorepo: a Rails API (`backend/`) and a Vue 3 SPA (`frontend/`).

## Layout

```
rails_boilerplate/
├── backend/            # Rails 8 API — Postgres, Redis, Elasticsearch, Sidekiq
│   └── docker-compose.yml
├── frontend/           # Vue 3 + Vite + Pinia + Tailwind + Vitest
│   └── Dockerfile
├── docker-compose.yml  # root compose — includes backend, adds frontend
└── README.md
```

## Quick start

The root `docker-compose.yml` runs **both** projects with a single command. It uses Compose's `include:` directive to pull in `backend/docker-compose.yml`, so the backend stack (database, redis, elasticsearch, web, sidekiq) plus the frontend dev server come up together.

```bash
# 1. one-time backend env setup
cp backend/.env.example backend/.env

# 2. boot everything
docker compose up

# 3. (first run only, in another terminal) seed the database
docker compose exec web bin/rails db:setup
```

Services exposed on the host:

| Service       | URL                              | Notes                                    |
|---------------|----------------------------------|------------------------------------------|
| Frontend      | http://localhost:5173            | Vite dev server with HMR                 |
| Rails API     | http://localhost:3002            | Container port 3000 mapped to host 3002  |
| Swagger docs  | http://localhost:3002/api-docs   |                                          |
| GraphiQL      | http://localhost:3002/graphiql   |                                          |
| Sidekiq       | http://localhost:3002/sidekiq    |                                          |
| Admin         | http://localhost:3002/admin      |                                          |
| Postgres      | localhost:5433                   | user/pass: `postgres` / `postgres`       |
| Elasticsearch | http://localhost:9200            |                                          |
| Redis         | localhost:6380                   |                                          |

The frontend is preconfigured to call the API at `http://localhost:3002` via the `VITE_API_BASE_URL` env var. Override it from the shell if your setup differs:

```bash
VITE_API_BASE_URL=http://localhost:9000 docker compose up
```

## Common commands

```bash
docker compose up                              # start everything
docker compose up -d                           # detached
docker compose down                            # stop and remove containers
docker compose logs -f frontend                # tail frontend logs
docker compose logs -f web                     # tail backend logs
docker compose exec web bash                   # shell into the Rails container
docker compose exec frontend sh                # shell into the frontend container
```

### Backend

```bash
docker compose exec web bundle exec bin/rspec -P ./*/**/*_spec.rb   # run specs
docker compose exec web bundle exec bin/lint                        # rubocop + reek
docker compose exec web bundle exec bin/scan                        # brakeman
docker compose exec web bundle exec bin/packwerk check              # packwerk
```

See [`backend/CLAUDE.md`](backend/CLAUDE.md) for architectural detail (ServiceActor, Pundit, Packwerk, ApiRequestLog observability, etc.).

### Frontend

```bash
docker compose exec frontend yarn test         # vitest watch
docker compose exec frontend yarn test:run     # vitest single run
docker compose exec frontend yarn lint         # eslint
docker compose exec frontend yarn build        # production build
```

The frontend follows a layered architecture (services → composables → stores → components). Service objects live in `frontend/src/services/`, composables in `frontend/src/composables/`, and the Pinia auth store in `frontend/src/stores/`. See `frontend/src/main.js` for how the service container is wired via `provide`/`inject`.

## Running outside Docker

You can also run each side natively if you prefer:

```bash
# backend (still needs postgres/redis/elasticsearch running somehow)
cd backend && bin/dev

# frontend
cd frontend && yarn install && yarn dev
```

If you run the backend on host port 3000 instead of 3002, override the API URL for the frontend:

```bash
echo 'VITE_API_BASE_URL=http://localhost:3000' > frontend/.env.local
```
