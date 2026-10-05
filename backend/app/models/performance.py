from sqlalchemy import Column, Integer, Date, Numeric, DateTime, ForeignKey
from datetime import datetime
from app.database import Base

class DailyPerformance(Base):
    __tablename__ = "daily_performance"

    id = Column(Integer, primary_key=True, index=True)
    campaign_id = Column(Integer, ForeignKey("campaigns.id"), nullable=False, index=True)
    placement_id = Column(Integer, ForeignKey("ad_placements.id"), nullable=False)
    date = Column(Date, nullable=False, index=True)
    impressions = Column(Integer, default=0)
    clicks = Column(Integer, default=0)
    conversions = Column(Integer, default=0)
    installs = Column(Integer, default=0)
    views = Column(Integer, default=0)
    engagements = Column(Integer, default=0)
    unique_users = Column(Integer, default=0)
    total_spend = Column(Numeric(12, 2), default=0)
    total_revenue = Column(Numeric(12, 2), default=0)
    ctr = Column(Numeric(5, 2))
    cpc = Column(Numeric(10, 2))
    cpa = Column(Numeric(10, 2))
    roas = Column(Numeric(5, 2))
    conversion_rate = Column(Numeric(5, 2))
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
