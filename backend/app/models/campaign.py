from sqlalchemy import Column, Integer, String, Text, Numeric, Boolean, DateTime, ForeignKey, JSON
from sqlalchemy.orm import relationship
from datetime import datetime
from app.database import Base

class Campaign(Base):
    __tablename__ = "campaigns"

    id = Column(Integer, primary_key=True, index=True)
    advertiser_id = Column(Integer, ForeignKey("advertisers.id"), nullable=False)
    campaign_name = Column(String(255), nullable=False)
    campaign_type = Column(String(50), nullable=False)  # cpm, cpc, cpa, cpi, cpv
    ad_format = Column(String(50), nullable=False)  # banner, interstitial, rewarded, native, video
    title = Column(String(255), nullable=False)
    description = Column(Text)
    body_text = Column(Text)
    creative_image_url = Column(String(255))
    creative_video_url = Column(String(255))
    destination_url = Column(String(255), nullable=False)
    call_to_action = Column(String(100), default="Learn More")
    daily_budget = Column(Numeric(12, 2))
    total_budget = Column(Numeric(12, 2))
    spent_budget = Column(Numeric(12, 2), default=0)
    bid_amount = Column(Numeric(10, 2), nullable=False)
    status = Column(String(50), default="draft")  # draft, pending_review, active, paused, completed, rejected
    targeting_json = Column(JSON)
    exclusions_json = Column(JSON)
    frequency_cap = Column(Integer, default=3)
    start_date = Column(DateTime)
    end_date = Column(DateTime)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    advertiser = relationship("Advertiser", back_populates="campaigns")
    placements = relationship("CampaignPlacement", back_populates="campaign", cascade="all, delete-orphan")
    events = relationship("AdEvent", back_populates="campaign")

class CampaignPlacement(Base):
    __tablename__ = "campaign_placements"

    id = Column(Integer, primary_key=True, index=True)
    campaign_id = Column(Integer, ForeignKey("campaigns.id"), nullable=False)
    placement_id = Column(Integer, ForeignKey("ad_placements.id"), nullable=False)
    daily_budget = Column(Numeric(12, 2))
    status = Column(String(50), default="active")
    placement_bid_override = Column(Numeric(10, 2))
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    campaign = relationship("Campaign", back_populates="placements")
    placement = relationship("AdPlacement", back_populates="campaigns")
