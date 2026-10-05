# Backend Project Structure

```
backend/
├── main.py                 # FastAPI app entry point
├── config.py              # Configuration and settings
├── requirements.txt       # Python dependencies
├── database.py            # Database connection and session management
├── models/
│   ├── __init__.py
│   ├── user.py
│   ├── advertiser.py
│   ├── publisher.py
│   ├── campaign.py
│   ├── event.py
│   └── transaction.py
├── schemas/
│   ├── __init__.py
│   ├── advertiser.py
│   ├── publisher.py
│   ├── campaign.py
│   ├── event.py
│   └── common.py
├── api/
│   ├── __init__.py
│   ├── v1/
│   │   ├── __init__.py
│   │   ├── advertisers.py      # Advertiser routes
│   │   ├── publishers.py       # Publisher routes
│   │   ├── campaigns.py        # Campaign routes
│   │   ├── placements.py       # Placement routes
│   │   ├── ads.py              # Ad serving and tracking
│   │   ├── analytics.py        # Performance and analytics
│   │   ├── billing.py          # Billing and transactions
│   │   └── health.py           # Health check
├── services/
│   ├── __init__.py
│   ├── ad_server.py            # Ad serving logic
│   ├── analytics_service.py    # Analytics aggregation
│   ├── billing_service.py      # Billing logic
│   ├── fraud_detection.py      # Fraud detection
│   └── email_service.py        # Email notifications
├── middleware/
│   ├── __init__.py
│   ├── auth.py                 # Authentication middleware
│   ├── rate_limit.py           # Rate limiting
│   └── logging.py              # Request logging
├── utils/
│   ├── __init__.py
│   ├── crypto.py               # Password hashing
│   ├── validators.py           # Input validation
│   └── constants.py            # Constants
└── logs/                       # Log files
    └── app.log
```

## Running the Project

```bash
# Install dependencies
pip install -r requirements.txt

# Set environment variables
cp .env.example .env

# Run with docker-compose
docker-compose up --build

# Or run locally
uvicorn main:app --reload

# Access API docs at http://localhost:8000/docs
```
