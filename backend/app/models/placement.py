from sqlalchemy import Column, Integer, String, Boolean, Numeric, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime
from app.database import Base

class AdPlacement(Base):
    __tablename__ = "ad_placements"

    id = Column(Integer, primary_key=True, index=True)
    app_id = Column(Integer, ForeignKey("publisher_apps.id"), nullable=False)
    placement_name = Column(String(255), nullable=False)
    placement_type = Column(String(50), nullable=False)  # banner, interstitial, rewarded, native
    placement_size = Column(String(50))
    placement_code = Column(String(100), unique=True, nullable=False, index=True)
    position = Column(String(100))  # top, middle, bottom
    minimum_bid = Column(Numeric(10, 2), default=0.10)
    expected_impressions_per_day = Column(Integer)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    app = relationship("PublisherApp", back_populates="placements")
    campaigns = relationship("CampaignPlacement", back_populates="placement", cascade="all, delete-orphan")
