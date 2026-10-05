# Ads Aggregation Platform - Backend API

## Project Structure

```
backend/
├── app/
│   ├── api/
│   │   └── v1/
│   │       ├── auth.py              # Authentication routes
│   │       ├── advertisers.py        # Advertiser CRUD
│   │       ├── publishers.py         # Publisher CRUD
│   │       ├── campaigns.py          # Campaign management
│   │       ├── placements.py         # Ad placement routes
│   │       ├── ads.py                # Ad serving & tracking
│   │       ├── analytics.py          # Performance analytics
│   │       ├── billing.py            # Billing & transactions
│   │       └── health.py             # Health check
│   ├── core/
│   │   ├── security.py               # JWT & password hashing
│   │   └── auth.py                   # Authentication dependencies
│   ├── models/
│   │   ├── user.py
│   │   ├── advertiser.py
│   │   ├── publisher.py
│   │   ├── app.py                    # PublisherApp model
│   │   ├── placement.py              # AdPlacement model
│   │   ├── campaign.py               # Campaign model
│   │   ├── event.py                  # AdEvent model
│   │   ├── performance.py            # DailyPerformance model
│   │   └── transaction.py            # Transaction model
│   ├── schemas/
│   │   ├── user.py                   # User Pydantic schemas
│   │   ├── advertiser.py             # Advertiser schemas
│   │   ├── publisher.py              # Publisher schemas
│   │   └── campaign.py               # Campaign schemas
│   ├── services/
│   │   ├── user_service.py           # User business logic
│   │   ├── ad_server.py              # Ad serving logic
│   │   ├── analytics_service.py      # Analytics aggregation
│   │   ├── billing_service.py        # Billing logic
│   │   └── fraud_service.py          # Fraud detection
│   ├── config.py                     # Configuration & settings
│   ├── database.py                   # Database connection
│   └── main.py                       # FastAPI app entry point
├── requirements.txt
├── Dockerfile
├── .env.example
└── README.md
```

## Setup Instructions

### Prerequisites
- Docker & Docker Compose
- Python 3.11+ (for local development)
- PostgreSQL 16 (or use Docker)
- Redis (or use Docker)

### Using Docker Compose (Recommended)

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ads-aggregation-platform
   ```

2. **Setup environment variables**
   ```bash
   cd backend
   cp .env.example .env
   ```
   Edit `.env` with your configuration if needed.

3. **Start all services**
   ```bash
   cd ..
   docker-compose up --build
   ```

4. **Create database tables** (optional - seed data will initialize them)
   ```bash
   docker-compose exec api python -c "from app.database import Base, engine; Base.metadata.create_all(bind=engine)"
   ```

5. **Access the API**
   - API: http://localhost:8000
   - API Docs (Swagger): http://localhost:8000/docs
   - API ReDoc: http://localhost:8000/redoc
   - Database: localhost:5432 (ads_admin / ads_secure_password)
   - Redis: localhost:6379

### Local Development (without Docker)

1. **Create a virtual environment**
   ```bash
   cd backend
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

3. **Setup PostgreSQL**
   ```bash
   # Create database
   createdb ads_platform
   
   # Load schema and seed data
   psql ads_platform < ../database/schema.sql
   psql ads_platform < ../database/seed_data.sql
   ```

4. **Copy and configure .env**
   ```bash
   cp .env.example .env
   # Edit .env to point to your local database
   DATABASE_URL=postgresql://ads_admin:ads_secure_password@localhost:5432/ads_platform
   ```

5. **Run the server**
   ```bash
   uvicorn app.main:app --reload
   ```

## API Endpoints

### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login and get tokens
- `POST /api/v1/auth/refresh` - Refresh access token
- `GET /api/v1/auth/me` - Get current user info

### Advertisers
- `POST /api/v1/advertisers/` - Create advertiser
- `GET /api/v1/advertisers/{id}` - Get advertiser
- `PUT /api/v1/advertisers/{id}` - Update advertiser

### Publishers
- `POST /api/v1/publishers/` - Create publisher
- `GET /api/v1/publishers/{id}` - Get publisher
- `PUT /api/v1/publishers/{id}` - Update publisher

### Health
- `GET /api/v1/health` - Health check

## Authentication

All protected endpoints require a Bearer token in the Authorization header:

```bash
Authorization: Bearer <access_token>
```

Get a token by:
1. Register: `POST /api/v1/auth/register`
2. Login: `POST /api/v1/auth/login`

## Example Usage

### Register a new user
```bash
curl -X POST http://localhost:8000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_acme",
    "email": "john@acme.com",
    "password": "secure_password_123",
    "full_name": "John Smith",
    "role": "advertiser"
  }'
```

### Login
```bash
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@acme.com",
    "password": "secure_password_123"
  }'
```

Response:
```json
{
  "access_token": "eyJhbGc...",
  "refresh_token": "eyJhbGc...",
  "token_type": "bearer",
  "expires_in": 1800
}
```

### Create advertiser (authenticated)
```bash
curl -X POST http://localhost:8000/api/v1/advertisers/ \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "company_name": "Acme Inc",
    "website_url": "https://acme.com",
    "description": "E-commerce brand",
    "billing_email": "billing@acme.com"
  }'
```

## Database

PostgreSQL database with the following main tables:
- `users` - User accounts
- `advertisers` - Advertiser accounts
- `publishers` - Publisher accounts
- `publisher_apps` - Publisher apps/channels
- `ad_placements` - Ad placement slots
- `campaigns` - Ad campaigns
- `campaign_placements` - Campaign to placement mappings
- `ad_events` - Ad impressions, clicks, conversions
- `daily_performance` - Aggregated daily metrics
- `transactions` - Billing records

## Common Tasks

### View logs
```bash
# Docker logs
docker-compose logs -f api

# Or in container
docker-compose exec api tail -f /app/logs/app.log
```

### Access database
```bash
# Via Docker
docker-compose exec postgres psql -U ads_admin -d ads_platform

# Via local psql
psql -h localhost -U ads_admin -d ads_platform
```

### Stop services
```bash
docker-compose down
```

### Remove all data
```bash
docker-compose down -v
```

## Security Notes

1. **Change SECRET_KEY in production**
   - Generate a strong secret key
   - Update in `.env` file

2. **Use environment variables for sensitive data**
   - Database credentials
   - API keys
   - JWT secret

3. **Enable HTTPS in production**
   - Use reverse proxy (nginx)
   - Configure SSL certificates

4. **Implement rate limiting**
   - Already configured in config.py
   - Integrate with Redis

5. **API Key authentication for publishers**
   - Header: `x-api-key: <api_key>`

## Troubleshooting

### Connection refused on port 5432
- Postgres container not running
- Run: `docker-compose up postgres -d`

### "already in use" error
- Port is already in use
- Change port in docker-compose.yml
- Or kill the process: `lsof -i :8000`

### Database migration issues
- Delete volume and restart
- Run: `docker-compose down -v && docker-compose up`

## Next Steps

1. Implement remaining API routes (campaigns, placements, ads, analytics)
2. Add rate limiting middleware
3. Implement ad serving logic
4. Add fraud detection
5. Implement billing/payout system
6. Create React admin dashboards
7. Add email notifications
8. Setup CI/CD pipeline
