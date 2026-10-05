from sqlalchemy import Column, Integer, String, Text, Boolean, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime
from app.database import Base

class PublisherApp(Base):
    __tablename__ = "publisher_apps"

    id = Column(Integer, primary_key=True, index=True)
    publisher_id = Column(Integer, ForeignKey("publishers.id"), nullable=False)
    app_name = Column(String(255), nullable=False)
    app_type = Column(String(50), nullable=False)  # mobile, web, desktop, telegram_channel
    platform = Column(String(50), nullable=False)  # ios, android, web, telegram
    app_identifier = Column(String(255))
    website_url = Column(String(255))
    app_store_url = Column(String(255))
    description = Column(Text)
    category = Column(String(100))
    total_users = Column(Integer, default=0)
    monthly_active_users = Column(Integer, default=0)
    daily_active_users = Column(Integer, default=0)
    language = Column(String(10), default="en")
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    publisher = relationship("Publisher", back_populates="apps")
    placements = relationship("AdPlacement", back_populates="app", cascade="all, delete-orphan")
