from typing import Optional, List
from datetime import datetime
from pydantic import BaseModel, EmailStr, Field


# ========== ADVERTISER SCHEMAS ==========
class AdvertiserCreateRequest(BaseModel):
    user_id: int
    company_name: str
    website: Optional[str] = None
    description: Optional[str] = None
    billing_email: str


class AdvertiserResponse(BaseModel):
    id: int
    user_id: int
    company_name: str
    website: Optional[str]
    description: Optional[str]
    account_balance: float
    verification_status: str
    is_suspended: bool
    created_at: Optional[datetime]

    class Config:
        from_attributes = True


class AdvertiserUpdateRequest(BaseModel):
    company_name: Optional[str] = None
    website: Optional[str] = None
    description: Optional[str] = None
    logo_url: Optional[str] = None
    monthly_spend_limit: Optional[float] = None


# ========== CAMPAIGN SCHEMAS ==========
class CampaignTargeting(BaseModel):
    """Targeting criteria for campaigns"""
    countries: Optional[List[str]] = []
    regions: Optional[List[str]] = []
    min_age: Optional[int] = None
    max_age: Optional[int] = None
    genders: Optional[List[str]] = []  # ['M', 'F', 'Other']
    device_types: Optional[List[str]] = []  # ['mobile', 'tablet', 'desktop']
    os_types: Optional[List[str]] = []  # ['ios', 'android', 'windows']
    app_categories: Optional[List[str]] = []  # ['gaming', 'news', 'education']


class CampaignCreateRequest(BaseModel):
    advertiser_id: int
    campaign_name: str
    campaign_type: str = Field(..., description="'cpm', 'cpc', 'cpv', 'cpa'")
    ad_format: str = Field(..., description="'banner', 'interstitial', 'rewarded', 'native'")
    title: str
    description: Optional[str] = None
    creative_image_url: Optional[str] = None
    creative_video_url: Optional[str] = None
    destination_url: str
    call_to_action: str = "Learn More"
    daily_budget: Optional[float] = None
    total_budget: Optional[float] = None
    bid_amount: float = Field(..., gt=0, description="Bid in cents for CPM/CPC/CPA")
    frequency_cap: int = Field(default=3, description="Max impressions per user per day")
    start_date: Optional[datetime] = None
    end_date: Optional[datetime] = None
    targeting: Optional[CampaignTargeting] = None
    placement_ids: Optional[List[int]] = []


class CampaignUpdateRequest(BaseModel):
    campaign_name: Optional[str] = None
    title: Optional[str] = None
    description: Optional[str] = None
    daily_budget: Optional[float] = None
    bid_amount: Optional[float] = None
    status: Optional[str] = None  # 'active', 'paused', 'draft'
    targeting: Optional[CampaignTargeting] = None


class CampaignResponse(BaseModel):
    id: int
    advertiser_id: int
    campaign_name: str
    campaign_type: str
    ad_format: str
    title: str
    description: Optional[str]
    destination_url: str
    daily_budget: Optional[float]
    total_budget: Optional[float]
    spent_budget: float
    bid_amount: float
    status: str
    frequency_cap: int
    start_date: Optional[datetime]
    end_date: Optional[datetime]
    created_at: Optional[datetime]
    updated_at: Optional[datetime]

    class Config:
        from_attributes = True


class CampaignPerformanceResponse(BaseModel):
    campaign_id: int
    campaign_name: str
    date: str
    impressions: int
    clicks: int
    conversions: int
    total_spend: float
    ctr: Optional[float]
    cpc: Optional[float]
    roas: Optional[float]


# ========== PUBLISHER SCHEMAS ==========
class PublisherCreateRequest(BaseModel):
    user_id: int
    company_name: str
    website: Optional[str] = None
    description: Optional[str] = None
    payout_email: str
    payout_method: Optional[str] = None


class PublisherResponse(BaseModel):
    id: int
    user_id: int
    company_name: str
    website: Optional[str]
    description: Optional[str]
    api_key: str
    account_balance: float
    total_earnings: float
    minimum_payout: float
    verification_status: str
    is_suspended: bool
    created_at: Optional[datetime]

    class Config:
        from_attributes = True


class PublisherUpdateRequest(BaseModel):
    company_name: Optional[str] = None
    website: Optional[str] = None
    description: Optional[str] = None
    minimum_payout: Optional[float] = None
    payout_method: Optional[str] = None


# ========== PUBLISHER APP SCHEMAS ==========
class PublisherAppCreateRequest(BaseModel):
    publisher_id: int
    app_name: str
    app_type: str = Field(..., description="'mobile', 'web', 'desktop'")
    platform: str = Field(..., description="'ios', 'android', 'web', 'windows'")
    category: Optional[str] = None
    description: Optional[str] = None
    app_store_url: Optional[str] = None
    website_url: Optional[str] = None
    total_users: int = 0
    monthly_active_users: int = 0


class PublisherAppResponse(BaseModel):
    id: int
    publisher_id: int
    app_name: str
    app_type: str
    platform: str
    category: Optional[str]
    description: Optional[str]
    total_users: int
    monthly_active_users: int
    is_active: bool
    created_at: Optional[datetime]

    class Config:
        from_attributes = True


# ========== AD PLACEMENT SCHEMAS ==========
class AdPlacementCreateRequest(BaseModel):
    app_id: int
    placement_name: str
    placement_type: str = Field(..., description="'banner', 'interstitial', 'rewarded', 'native'")
    placement_size: Optional[str] = None
    minimum_bid: float = 0.1


class AdPlacementResponse(BaseModel):
    id: int
    app_id: int
    placement_name: str
    placement_type: str
    placement_size: Optional[str]
    placement_code: str
    minimum_bid: float
    is_active: bool
    created_at: Optional[datetime]

    class Config:
        from_attributes = True


# ========== AD SERVING SCHEMAS ==========
class AdServeRequest(BaseModel):
    placement_code: str
    user_id_hash: Optional[str] = None
    session_id: Optional[str] = None
    geo: Optional[dict] = None
    device: Optional[dict] = None
    user_agent: Optional[str] = None
    ip_address: Optional[str] = None


class AdServeResponse(BaseModel):
    campaign_id: int
    campaign_name: str
    ad_format: str
    title: str
    description: Optional[str]
    destination_url: str
    call_to_action: str
    creative_image_url: Optional[str]
    creative_video_url: Optional[str]
    impression_tracking_url: Optional[str]
    click_tracking_url: Optional[str]


# ========== EVENT TRACKING SCHEMAS ==========
class AdEventRequest(BaseModel):
    placement_code: str
    campaign_id: int
    event_type: str = Field(..., description="'impression', 'click', 'conversion', 'install'")
    user_id_hash: Optional[str] = None
    session_id: Optional[str] = None
    geo: Optional[dict] = None
    device: Optional[dict] = None
    user_agent: Optional[str] = None
    ip_address: Optional[str] = None
    conversion_value: Optional[float] = None


class AdEventResponse(BaseModel):
    status: str
    event_id: int
    revenue: float


# ========== PAYOUT SCHEMAS ==========
class PublisherPayoutResponse(BaseModel):
    id: int
    publisher_id: int
    amount: float
    currency: str
    status: str
    period_start: Optional[str]
    period_end: Optional[str]
    created_at: Optional[datetime]

    class Config:
        from_attributes = True
