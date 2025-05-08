
# Rails Application - Docker Setup Guide

## 🧰 Prerequisites

- Docker
- Docker Compose

## 🚀 Quick Start

1. **Build and start the containers:**

   ```bash
   docker-compose build
   docker-compose up -d
   ```

2. **Set up the database:**

   ```bash
   docker-compose exec app rails db:create
   docker-compose exec app rails db:migrate
   ```

3. **Access the app:**

   Visit [http://localhost:3000](http://localhost:3000)

## 🧪 Running Tests

```bash
docker-compose exec app bundle exec rspec
```

## 🛠 Useful Commands

- **Rails console:**

  ```bash
  docker-compose exec app rails console
  ```

- **Install new gem:**

  1. Add to `Gemfile`
  2. Run:

     ```bash
     docker-compose exec app bundle install
     ```