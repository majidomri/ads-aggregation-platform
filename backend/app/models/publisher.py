from sqlalchemy import Column, Integer, String, Text, Numeric, Boolean, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime
from app.database import Base

class Publisher(Base):
    __tablename__ = "publishers"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), unique=True, nullable=False)
    company_name = Column(String(255), nullable=False)
    website_url = Column(String(255))
    description = Column(Text)
    api_key = Column(String(255), unique=True, nullable=False, index=True)
    api_secret = Column(String(255), nullable=False)
    account_balance = Column(Numeric(12, 2), default=0)
    total_earnings = Column(Numeric(12, 2), default=0)
    pending_payout = Column(Numeric(12, 2), default=0)
    payout_method = Column(String(50))  # paypal, bank_transfer, crypto
    payout_email = Column(String(255))
    is_verified = Column(Boolean, default=False)
    verification_status = Column(String(50), default="pending")
    is_suspended = Column(Boolean, default=False)
    minimum_payout_amount = Column(Numeric(12, 2), default=100)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    apps = relationship("PublisherApp", back_populates="publisher", cascade="all, delete-orphan")
