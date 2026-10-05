from typing import Optional
from pydantic import BaseModel
from datetime import datetime

class AdvertiserCreate(BaseModel):
    user_id: int
    company_name: str
    website_url: Optional[str] = None
    description: Optional[str] = None
    billing_email: Optional[str] = None
    industry: Optional[str] = None

class AdvertiserUpdate(BaseModel):
    company_name: Optional[str] = None
    website_url: Optional[str] = None
    description: Optional[str] = None
    billing_email: Optional[str] = None
    industry: Optional[str] = None

class AdvertiserOut(BaseModel):
    id: int
    user_id: int
    company_name: str
    website_url: Optional[str]
    description: Optional[str]
    account_balance: float
    total_spent: float
    verification_status: str
    is_suspended: bool
    created_at: datetime

    class Config:
        from_attributes = True
