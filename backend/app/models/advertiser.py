from sqlalchemy import Column, Integer, String, Text, Numeric, Boolean, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime
from app.database import Base

class Advertiser(Base):
    __tablename__ = "advertisers"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), unique=True, nullable=False)
    company_name = Column(String(255), nullable=False)
    website_url = Column(String(255))
    description = Column(Text)
    billing_email = Column(String(255))
    industry = Column(String(100))
    account_balance = Column(Numeric(12, 2), default=0)
    total_spent = Column(Numeric(12, 2), default=0)
    monthly_spend_limit = Column(Numeric(12, 2))
    daily_spend_limit = Column(Numeric(12, 2))
    is_verified = Column(Boolean, default=False)
    verification_status = Column(String(50), default="pending")  # pending, approved, rejected, suspended
    is_suspended = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    campaigns = relationship("Campaign", back_populates="advertiser", cascade="all, delete-orphan")
