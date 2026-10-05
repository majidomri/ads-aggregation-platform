from typing import Optional
from pydantic import BaseModel
from datetime import datetime

class PublisherCreate(BaseModel):
    user_id: int
    company_name: str
    website_url: Optional[str] = None
    description: Optional[str] = None
    payout_method: Optional[str] = None
    payout_email: Optional[str] = None

class PublisherUpdate(BaseModel):
    company_name: Optional[str] = None
    website_url: Optional[str] = None
    description: Optional[str] = None
    payout_method: Optional[str] = None
    payout_email: Optional[str] = None

class PublisherOut(BaseModel):
    id: int
    user_id: int
    company_name: str
    website_url: Optional[str]
    api_key: str
    account_balance: float
    total_earnings: float
    verification_status: str
    created_at: datetime

    class Config:
        from_attributes = True
