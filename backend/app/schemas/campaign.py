from typing import Optional, List, Dict, Any
from pydantic import BaseModel, HttpUrl
from datetime import datetime

class CampaignCreate(BaseModel):
    campaign_name: str
    campaign_type: str  # cpm, cpc, cpa, cpi, cpv
    ad_format: str  # banner, interstitial, rewarded, native, video
    title: str
    description: Optional[str] = None
    body_text: Optional[str] = None
    creative_image_url: Optional[str] = None
    creative_video_url: Optional[str] = None
    destination_url: str
    call_to_action: Optional[str] = "Learn More"
    daily_budget: Optional[float] = None
    total_budget: Optional[float] = None
    bid_amount: float
    targeting_json: Optional[Dict[str, Any]] = None
    exclusions_json: Optional[Dict[str, Any]] = None
    frequency_cap: Optional[int] = 3
    start_date: Optional[datetime] = None
    end_date: Optional[datetime] = None

class CampaignUpdate(BaseModel):\n    campaign_name: Optional[str] = None
    title: Optional[str] = None
    description: Optional[str] = None
    body_text: Optional[str] = None
    creative_image_url: Optional[str] = None
    creative_video_url: Optional[str] = None
    destination_url: Optional[str] = None
    call_to_action: Optional[str] = None
    daily_budget: Optional[float] = None
    total_budget: Optional[float] = None
    bid_amount: Optional[float] = None
    status: Optional[str] = None  # draft, pending_review, active, paused, completed
    targeting_json: Optional[Dict[str, Any]] = None
    exclusions_json: Optional[Dict[str, Any]] = None
    frequency_cap: Optional[int] = None
    start_date: Optional[datetime] = None
    end_date: Optional[datetime] = None

class CampaignOut(BaseModel):
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
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class CampaignPlacementCreate(BaseModel):
    campaign_id: int
    placement_id: int
    daily_budget: Optional[float] = None
    placement_bid_override: Optional[float] = None

class CampaignPlacementOut(BaseModel):
    id: int
    campaign_id: int
    placement_id: int
    daily_budget: Optional[float]
    status: str
    placement_bid_override: Optional[float]
    created_at: datetime

    class Config:
        from_attributes = True

class CampaignStatsOut(BaseModel):
    campaign_id: int
    total_impressions: int
    total_clicks: int
    total_conversions: int
    total_spend: float
    ctr: float  # Click-through rate
    cpc: float  # Cost per click
    cpa: float  # Cost per acquisition
    roas: float  # Return on ad spend
