from datetime import datetime
from uuid import uuid4
from fastapi import APIRouter, Depends, HTTPException, status, Header
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.publisher import Publisher
from app.models.user import User
from app.schemas.publisher import PublisherCreate, PublisherUpdate, PublisherOut
from app.core.auth import get_current_publisher_user

router = APIRouter(prefix="/publishers", tags=["publishers"])

def generate_api_key() -> str:
    return "pk_" + str(uuid4()).replace("-", "")[:20]

def generate_api_secret() -> str:
    return "sk_" + str(uuid4()).replace("-", "")[:30]

@router.post("/", response_model=PublisherOut, status_code=status.HTTP_201_CREATED)
def create_publisher(
    payload: PublisherCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_publisher_user)
):
    existing = db.query(Publisher).filter(Publisher.user_id == payload.user_id).first()
    if existing:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="Publisher already exists")

    publisher = Publisher(
        user_id=payload.user_id,
        company_name=payload.company_name,
        website_url=payload.website_url,
        description=payload.description,
        api_key=generate_api_key(),
        api_secret=generate_api_secret(),
        payout_method=payload.payout_method,
        payout_email=payload.payout_email,
        created_at=datetime.utcnow(),
        updated_at=datetime.utcnow(),
    )
    db.add(publisher)
    db.commit()
    db.refresh(publisher)
    return publisher

@router.get("/{publisher_id}", response_model=PublisherOut)
def get_publisher(publisher_id: int, db: Session = Depends(get_db)):
    publisher = db.query(Publisher).filter(Publisher.id == publisher_id).first()
    if not publisher:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Publisher not found")
    return publisher

@router.put("/{publisher_id}", response_model=PublisherOut)
def update_publisher(
    publisher_id: int,
    payload: PublisherUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_publisher_user)
):
    publisher = db.query(Publisher).filter(Publisher.id == publisher_id).first()
    if not publisher:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Publisher not found")

    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(publisher, field, value)

    publisher.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(publisher)
    return publisher
