from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.advertiser import Advertiser
from app.models.user import User
from app.schemas.advertiser import AdvertiserCreate, AdvertiserUpdate, AdvertiserOut
from app.core.auth import get_current_advertiser_user

router = APIRouter(prefix="/advertisers", tags=["advertisers"])

@router.post("/", response_model=AdvertiserOut, status_code=status.HTTP_201_CREATED)
def create_advertiser(
    payload: AdvertiserCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_advertiser_user)
):
    existing = db.query(Advertiser).filter(Advertiser.user_id == payload.user_id).first()
    if existing:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="Advertiser already exists")

    advertiser = Advertiser(
        user_id=payload.user_id,
        company_name=payload.company_name,
        website_url=payload.website_url,
        description=payload.description,
        billing_email=payload.billing_email,
        industry=payload.industry,
        created_at=datetime.utcnow(),
        updated_at=datetime.utcnow(),
    )
    db.add(advertiser)
    db.commit()
    db.refresh(advertiser)
    return advertiser

@router.get("/{advertiser_id}", response_model=AdvertiserOut)
def get_advertiser(advertiser_id: int, db: Session = Depends(get_db)):
    advertiser = db.query(Advertiser).filter(Advertiser.id == advertiser_id).first()
    if not advertiser:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Advertiser not found")
    return advertiser

@router.put("/{advertiser_id}", response_model=AdvertiserOut)
def update_advertiser(
    advertiser_id: int,
    payload: AdvertiserUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_advertiser_user)
):
    advertiser = db.query(Advertiser).filter(Advertiser.id == advertiser_id).first()
    if not advertiser:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Advertiser not found")

    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(advertiser, field, value)

    advertiser.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(advertiser)
    return advertiser
