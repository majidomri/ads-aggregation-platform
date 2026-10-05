from sqlalchemy import Boolean, Column, Date, Float, Integer, JSON, String, Text, TIMESTAMP, ForeignKey
from sqlalchemy.orm import relationship
from database import Base


# ========== ADVERTISER MODELS ==========
class Advertiser(Base):
    """Advertiser/Brand account"""
    __tablename__ = "advertisers"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, nullable=False, unique=True)
    company_name = Column(String(255), nullable=False)
    website = Column(String(255), nullable=True)
    logo_url = Column(String(255), nullable=True)
    description = Column(Text, nullable=True)
    billing_email = Column(String(255), nullable=True)
    account_balance = Column(Float, default=0.0)
    monthly_spend_limit = Column(Float, nullable=True)
    is_verified = Column(Boolean, default=False)
    verification_status = Column(String(50), default="pending")  # pending, approved, rejected
    is_suspended = Column(Boolean, default=False)
    created_at = Column(TIMESTAMP, nullable=True)
    updated_at = Column(TIMESTAMP, nullable=True)

    campaigns = relationship("InAppAdCampaign", back_populates="advertiser")


class InAppAdCampaign(Base):
    """In-app advertising campaign"""
    __tablename__ = "in_app_ad_campaigns"

    id = Column(Integer, primary_key=True, index=True)
    advertiser_id = Column(Integer, ForeignKey("advertisers.id"), nullable=False)
    campaign_name = Column(String(255), nullable=False)
    campaign_type = Column(String(50), nullable=False)  # 'cpm', 'cpc', 'cpv', 'cpa'
    ad_format = Column(String(50), nullable=False)  # 'banner', 'interstitial', 'rewarded', 'native'
    title = Column(String(255), nullable=False)
    description = Column(Text, nullable=True)
    creative_image_url = Column(String(255), nullable=True)
    creative_video_url = Column(String(255), nullable=True)
    destination_url = Column(String(255), nullable=False)
    call_to_action = Column(String(100), default="Learn More")
    daily_budget = Column(Float, nullable=True)
    total_budget = Column(Float, nullable=True)
    spent_budget = Column(Float, default=0.0)
    bid_amount = Column(Float, nullable=False)
    status = Column(String(50), default="draft")  # draft, pending_review, active, paused, completed, rejected
    targeting_json = Column(JSON, nullable=True)  # geo, device, os, demographics
    frequency_cap = Column(Integer, default=3)  # max impressions per user per day
    start_date = Column(TIMESTAMP, nullable=True)
    end_date = Column(TIMESTAMP, nullable=True)
    created_at = Column(TIMESTAMP, nullable=True)
    updated_at = Column(TIMESTAMP, nullable=True)

    advertiser = relationship("Advertiser", back_populates="campaigns")
    placements = relationship("CampaignPlacement", back_populates="campaign")
    events = relationship("AdEvent", back_populates="campaign")
    performance = relationship("InAppAdPerformance", back_populates="campaign")


class CampaignPlacement(Base):
    """Assignment of campaign to publisher placements"""
    __tablename__ = "campaign_placements"

    id = Column(Integer, primary_key=True, index=True)
    campaign_id = Column(Integer, ForeignKey("in_app_ad_campaigns.id"), nullable=False)
    placement_id = Column(Integer, ForeignKey("ad_placements.id"), nullable=False)
    daily_budget = Column(Float, nullable=True)
    daily_impressions_limit = Column(Integer, nullable=True)
    status = Column(String(50), default="active")  # active, paused, ended
    created_at = Column(TIMESTAMP, nullable=True)
    updated_at = Column(TIMESTAMP, nullable=True)

    campaign = relationship("InAppAdCampaign", back_populates="placements")
    placement = relationship("AdPlacement", back_populates="campaigns")


# ========== PUBLISHER MODELS ==========
class Publisher(Base):
    """Publisher/App Owner account"""
    __tablename__ = "publishers"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, nullable=False, unique=True)
    company_name = Column(String(255), nullable=False)
    website = Column(String(255), nullable=True)
    description = Column(Text, nullable=True)
    api_key = Column(String(255), unique=True, nullable=False, index=True)
    api_secret = Column(String(255), nullable=False)
    account_balance = Column(Float, default=0.0)
    total_earnings = Column(Float, default=0.0)
    payout_method = Column(String(50), nullable=True)  # bank_transfer, paypal, crypto
    payout_email = Column(String(255), nullable=True)
    minimum_payout = Column(Float, default=100.0)
    is_verified = Column(Boolean, default=False)
    verification_status = Column(String(50), default="pending")  # pending, approved, rejected
    is_suspended = Column(Boolean, default=False)
    created_at = Column(TIMESTAMP, nullable=True)
    updated_at = Column(TIMESTAMP, nullable=True)

    apps = relationship("PublisherApp", back_populates="publisher")
    payouts = relationship("PublisherPayout", back_populates="publisher")


class PublisherApp(Base):
    """App/Channel owned by a publisher"""
    __tablename__ = "publisher_apps"

    id = Column(Integer, primary_key=True, index=True)
    publisher_id = Column(Integer, ForeignKey("publishers.id"), nullable=False)
    app_name = Column(String(255), nullable=False)
    app_type = Column(String(50), nullable=False)  # 'mobile', 'web', 'desktop'
    platform = Column(String(50), nullable=False)  # 'ios', 'android', 'web', 'windows'
    app_store_url = Column(String(255), nullable=True)
    website_url = Column(String(255), nullable=True)
    description = Column(Text, nullable=True)
    category = Column(String(100), nullable=True)  # news, gaming, education, etc.
    icon_url = Column(String(255), nullable=True)
    is_active = Column(Boolean, default=True)
    total_users = Column(Integer, default=0)
    monthly_active_users = Column(Integer, default=0)
    created_at = Column(TIMESTAMP, nullable=True)
    updated_at = Column(TIMESTAMP, nullable=True)

    publisher = relationship("Publisher", back_populates="apps")
    placements = relationship("AdPlacement", back_populates="app")
    events = relationship("AdEvent", back_populates="app")


class AdPlacement(Base):
    """Ad placement slot in a publisher's app/website"""
    __tablename__ = "ad_placements"

    id = Column(Integer, primary_key=True, index=True)
    app_id = Column(Integer, ForeignKey("publisher_apps.id"), nullable=False)
    placement_name = Column(String(255), nullable=False)
    placement_type = Column(String(50), nullable=False)  # 'banner', 'interstitial', 'rewarded', 'native'
    placement_size = Column(String(50), nullable=True)  # '320x50', '300x250', 'fullscreen'
    placement_code = Column(String(100), unique=True, nullable=False)  # unique identifier
    minimum_bid = Column(Float, default=0.1)
    is_active = Column(Boolean, default=True)
    created_at = Column(TIMESTAMP, nullable=True)
    updated_at = Column(TIMESTAMP, nullable=True)

    app = relationship("PublisherApp", back_populates="placements")
    campaigns = relationship("CampaignPlacement", back_populates="placement")
    events = relationship("AdEvent", back_populates="placement")
    performance = relationship("InAppAdPerformance", back_populates="placement")


# ========== EVENT & PERFORMANCE MODELS ==========
class AdEvent(Base):
    """Ad event (impression, click, conversion)"""
    __tablename__ = "ad_events"

    id = Column(Integer, primary_key=True, index=True)
    campaign_id = Column(Integer, ForeignKey("in_app_ad_campaigns.id"), nullable=False)
    placement_id = Column(Integer, ForeignKey("ad_placements.id"), nullable=False)
    app_id = Column(Integer, ForeignKey("publisher_apps.id"), nullable=False)
    event_type = Column(String(50), nullable=False)  # 'impression', 'click', 'conversion', 'install'
    user_id_hash = Column(String(255), nullable=True)  # hashed for privacy
    session_id = Column(String(255), nullable=True)
    device_info = Column(JSON, nullable=True)  # {"os": "android", "version": "14", "brand": "samsung"}
    geo_location = Column(JSON, nullable=True)  # {"country": "US", "region": "CA", "city": "SF"}
    revenue = Column(Float, default=0.0)  # actual revenue generated by this event
    user_agent = Column(String(255), nullable=True)
    ip_address = Column(String(45), nullable=True)
    is_fraud = Column(Boolean, default=False)
    event_timestamp = Column(TIMESTAMP, nullable=True, index=True)
    created_at = Column(TIMESTAMP, nullable=True)

    campaign = relationship("InAppAdCampaign", back_populates="events")
    placement = relationship("AdPlacement", back_populates="events")
    app = relationship("PublisherApp", back_populates="events")


class InAppAdPerformance(Base):
    """Daily performance aggregated by campaign and placement"""
    __tablename__ = "in_app_ad_performance"

    id = Column(Integer, primary_key=True, index=True)
    campaign_id = Column(Integer, ForeignKey("in_app_ad_campaigns.id"), nullable=False)
    placement_id = Column(Integer, ForeignKey("ad_placements.id"), nullable=False)
    date = Column(Date, nullable=False, index=True)
    impressions = Column(Integer, default=0)
    clicks = Column(Integer, default=0)
    conversions = Column(Integer, default=0)
    installs = Column(Integer, default=0)
    total_spend = Column(Float, default=0.0)  # what advertiser paid
    total_revenue = Column(Float, default=0.0)  # what publisher earned
    ctr = Column(Float, nullable=True)  # click-through rate
    cpc = Column(Float, nullable=True)  # cost per click
    cpa = Column(Float, nullable=True)  # cost per action
    roas = Column(Float, nullable=True)  # return on ad spend
    created_at = Column(TIMESTAMP, nullable=True)
    updated_at = Column(TIMESTAMP, nullable=True)

    campaign = relationship("InAppAdCampaign", back_populates="performance")
    placement = relationship("AdPlacement", back_populates="performance")


# ========== BILLING & PAYOUT MODELS ==========
class PublisherPayout(Base):
    """Payout record for publishers"""
    __tablename__ = "publisher_payouts"

    id = Column(Integer, primary_key=True, index=True)
    publisher_id = Column(Integer, ForeignKey("publishers.id"), nullable=False)
    amount = Column(Float, nullable=False)
    currency = Column(String(10), default="USD")
    payout_method = Column(String(50), nullable=False)
    transaction_id = Column(String(255), nullable=True)
    status = Column(String(50), default="pending")  # pending, processing, completed, failed
    period_start = Column(Date, nullable=True)
    period_end = Column(Date, nullable=True)
    notes = Column(Text, nullable=True)
    created_at = Column(TIMESTAMP, nullable=True)
    updated_at = Column(TIMESTAMP, nullable=True)

    publisher = relationship("Publisher", back_populates="payouts")


class Transaction(Base):
    """Financial transaction (charges to advertisers, credits to publishers)"""
    __tablename__ = "transactions"

    id = Column(Integer, primary_key=True, index=True)
    advertiser_id = Column(Integer, ForeignKey("advertisers.id"), nullable=True)
    publisher_id = Column(Integer, ForeignKey("publishers.id"), nullable=True)
    transaction_type = Column(String(50), nullable=False)  # 'charge', 'credit', 'refund'
    amount = Column(Float, nullable=False)
    currency = Column(String(10), default="USD")
    related_event_id = Column(Integer, nullable=True)  # link to AdEvent if applicable
    status = Column(String(50), default="completed")  # pending, completed, failed
    description = Column(String(255), nullable=True)
    created_at = Column(TIMESTAMP, nullable=True)
