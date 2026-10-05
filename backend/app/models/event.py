from sqlalchemy import Column, Integer, String, Numeric, Boolean, DateTime, ForeignKey, JSON, BigInteger
from sqlalchemy.orm import relationship
from datetime import datetime
from app.database import Base

class AdEvent(Base):
    __tablename__ = "ad_events"

    id = Column(BigInteger, primary_key=True, index=True)
    campaign_id = Column(Integer, ForeignKey("campaigns.id"), nullable=False)
    placement_id = Column(Integer, ForeignKey("ad_placements.id"), nullable=False)
    app_id = Column(Integer, ForeignKey("publisher_apps.id"), nullable=False)
    advertiser_id = Column(Integer, ForeignKey("advertisers.id"), nullable=False)
    publisher_id = Column(Integer, ForeignKey("publishers.id"), nullable=False)
    event_type = Column(String(50), nullable=False, index=True)  # impression, click, conversion, install
    user_id_hash = Column(String(255), index=True)
    session_id = Column(String(255))
    request_id = Column(String(255))
    device_info = Column(JSON)
    geo_location = Column(JSON)
    user_agent = Column(String(500))
    ip_address = Column(String(45))
    conversion_value = Column(Numeric(12, 2), default=0)
    is_fraud = Column(Boolean, default=False, index=True)
    fraud_score = Column(Integer, default=0)
    revenue = Column(Numeric(12, 2), default=0)
    publisher_revenue = Column(Numeric(12, 2), default=0)
    platform_fee = Column(Numeric(12, 2), default=0)
    event_timestamp = Column(DateTime, nullable=False, index=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False, index=True)

    campaign = relationship("Campaign", back_populates="events")
