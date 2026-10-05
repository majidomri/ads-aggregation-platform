from sqlalchemy import Column, Integer, String, Numeric, DateTime, ForeignKey
from datetime import datetime
from app.database import Base

class Transaction(Base):
    __tablename__ = "transactions"

    id = Column(Integer, primary_key=True, index=True)
    advertiser_id = Column(Integer, ForeignKey("advertisers.id"), nullable=True)
    publisher_id = Column(Integer, ForeignKey("publishers.id"), nullable=True)
    transaction_type = Column(String(50), nullable=False)  # charge, credit, refund, payout
    amount = Column(Numeric(12, 2), nullable=False)
    currency = Column(String(10), default="USD")
    status = Column(String(50), default="completed")  # pending, completed, failed
    description = Column(String(255))
    reference_id = Column(String(255))
    metadata = Column(String(1000))
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False, index=True)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
