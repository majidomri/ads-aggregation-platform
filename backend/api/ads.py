import hashlib
import os
from datetime import datetime, timedelta
from fastapi import APIRouter, Depends, HTTPException, status, Header
from sqlalchemy.orm import Session
from sqlalchemy import func

from database import get_db
from models import (
    Advertiser,
    InAppAdCampaign,
    CampaignPlacement,
    Publisher,
    PublisherApp,
    AdPlacement,
    AdEvent,
    InAppAdPerformance,
)
from schemas import (
    AdvertiserCreateRequest,
    AdvertiserResponse,
    AdvertiserUpdateRequest,
    CampaignCreateRequest,
    CampaignUpdateRequest,
    CampaignResponse,
    CampaignPerformanceResponse,
    PublisherCreateRequest,
    PublisherResponse,
    PublisherUpdateRequest,
    PublisherAppCreateRequest,
    PublisherAppResponse,
    AdPlacementCreateRequest,
    AdPlacementResponse,
    AdServeRequest,
    AdServeResponse,
    AdEventRequest,
    AdEventResponse,
)

router = APIRouter(prefix="/api/v1", tags=["ads"])


def verify_api_key(api_key: str, db: Session) -> Publisher:
    """Verify publisher API key"""
    publisher = db.query(Publisher).filter(Publisher.api_key == api_key).first()
    if not publisher:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid API key")
    if publisher.is_suspended:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Publisher account suspended")
    return publisher


# ========== ADVERTISER ENDPOINTS ==========

@router.post("/advertisers", response_model=AdvertiserResponse)
def create_advertiser(payload: AdvertiserCreateRequest, db: Session = Depends(get_db)):
    """Create advertiser account"""
    existing = db.query(Advertiser).filter(Advertiser.user_id == payload.user_id).first()
    if existing:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="Advertiser already exists")

    advertiser = Advertiser(
        user_id=payload.user_id,
        company_name=payload.company_name,
        website=payload.website,
        description=payload.description,
        billing_email=payload.billing_email,
        created_at=datetime.utcnow(),
        updated_at=datetime.utcnow(),
    )
    db.add(advertiser)
    db.commit()
    db.refresh(advertiser)
    return advertiser


@router.get("/advertisers/{advertiser_id}", response_model=AdvertiserResponse)
def get_advertiser(advertiser_id: int, db: Session = Depends(get_db)):
    """Get advertiser details"""
    advertiser = db.query(Advertiser).filter(Advertiser.id == advertiser_id).first()
    if not advertiser:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Advertiser not found")
    return advertiser


@router.put("/advertisers/{advertiser_id}", response_model=AdvertiserResponse)
def update_advertiser(
    advertiser_id: int,
    payload: AdvertiserUpdateRequest,
    db: Session = Depends(get_db),
):
    """Update advertiser details"""
    advertiser = db.query(Advertiser).filter(Advertiser.id == advertiser_id).first()
    if not advertiser:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Advertiser not found")

    if payload.company_name:
        advertiser.company_name = payload.company_name
    if payload.website:
        advertiser.website = payload.website
    if payload.description is not None:
        advertiser.description = payload.description
    if payload.logo_url:
        advertiser.logo_url = payload.logo_url
    if payload.monthly_spend_limit is not None:
        advertiser.monthly_spend_limit = payload.monthly_spend_limit

    advertiser.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(advertiser)
    return advertiser


# ========== CAMPAIGN ENDPOINTS ==========

@router.post("/campaigns", response_model=CampaignResponse)
def create_campaign(payload: CampaignCreateRequest, db: Session = Depends(get_db)):
    """Create ad campaign"""
    advertiser = db.query(Advertiser).filter(Advertiser.id == payload.advertiser_id).first()
    if not advertiser:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Advertiser not found")
    if advertiser.is_suspended:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Advertiser suspended")

    campaign = InAppAdCampaign(
        advertiser_id=payload.advertiser_id,
        campaign_name=payload.campaign_name,
        campaign_type=payload.campaign_type,
        ad_format=payload.ad_format,
        title=payload.title,
        description=payload.description,
        creative_image_url=payload.creative_image_url,
        creative_video_url=payload.creative_video_url,
        destination_url=payload.destination_url,
        call_to_action=payload.call_to_action,
        daily_budget=payload.daily_budget,
        total_budget=payload.total_budget,
        bid_amount=payload.bid_amount,
        frequency_cap=payload.frequency_cap,
        start_date=payload.start_date,
        end_date=payload.end_date,
        targeting_json=payload.targeting.dict() if payload.targeting else None,
        status="draft",
        created_at=datetime.utcnow(),
        updated_at=datetime.utcnow(),
    )
    db.add(campaign)
    db.commit()
    db.refresh(campaign)

    # Assign to placements
    if payload.placement_ids:
        for placement_id in payload.placement_ids:
            placement = db.query(AdPlacement).filter(AdPlacement.id == placement_id).first()
            if placement:
                assignment = CampaignPlacement(
                    campaign_id=campaign.id,
                    placement_id=placement_id,
                    daily_budget=payload.daily_budget,
                    created_at=datetime.utcnow(),
                )
                db.add(assignment)
        db.commit()

    return campaign


@router.get("/campaigns/{campaign_id}", response_model=CampaignResponse)
def get_campaign(campaign_id: int, db: Session = Depends(get_db)):
    """Get campaign details"""
    campaign = db.query(InAppAdCampaign).filter(InAppAdCampaign.id == campaign_id).first()
    if not campaign:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Campaign not found")
    return campaign


@router.put("/campaigns/{campaign_id}", response_model=CampaignResponse)
def update_campaign(
    campaign_id: int,
    payload: CampaignUpdateRequest,
    db: Session = Depends(get_db),
):
    """Update campaign"""
    campaign = db.query(InAppAdCampaign).filter(InAppAdCampaign.id == campaign_id).first()
    if not campaign:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Campaign not found")

    if payload.campaign_name:
        campaign.campaign_name = payload.campaign_name
    if payload.title:
        campaign.title = payload.title
    if payload.description is not None:
        campaign.description = payload.description
    if payload.daily_budget is not None:
        campaign.daily_budget = payload.daily_budget
    if payload.bid_amount:
        campaign.bid_amount = payload.bid_amount
    if payload.status:
        campaign.status = payload.status
    if payload.targeting:
        campaign.targeting_json = payload.targeting.dict()

    campaign.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(campaign)
    return campaign


@router.get("/campaigns/{campaign_id}/performance")
def get_campaign_performance(campaign_id: int, days: int = 30, db: Session = Depends(get_db)):
    """Get campaign performance metrics"""
    campaign = db.query(InAppAdCampaign).filter(InAppAdCampaign.id == campaign_id).first()
    if not campaign:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Campaign not found")

    start_date = datetime.utcnow().date() - timedelta(days=days)
    performance = (
        db.query(InAppAdPerformance)
        .filter(
            InAppAdPerformance.campaign_id == campaign_id,
            InAppAdPerformance.date >= start_date,
        )
        .all()
    )

    return [
        CampaignPerformanceResponse(
            campaign_id=p.campaign_id,
            campaign_name=campaign.campaign_name,
            date=str(p.date),
            impressions=p.impressions,
            clicks=p.clicks,
            conversions=p.conversions,
            total_spend=p.total_spend,
            ctr=p.ctr,
            cpc=p.cpc,
            roas=p.roas,
        )
        for p in performance
    ]


# ========== PUBLISHER ENDPOINTS ==========

@router.post("/publishers", response_model=PublisherResponse)
def create_publisher(payload: PublisherCreateRequest, db: Session = Depends(get_db)):
    """Create publisher account"""
    existing = db.query(Publisher).filter(Publisher.user_id == payload.user_id).first()
    if existing:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="Publisher already exists")

    api_key = hashlib.sha256(f"{payload.user_id}{datetime.utcnow().isoformat()}".encode()).hexdigest()[:32]
    api_secret = hashlib.sha256(f"{api_key}{os.urandom(32).hex()}".encode()).hexdigest()

    publisher = Publisher(
        user_id=payload.user_id,
        company_name=payload.company_name,
        website=payload.website,
        description=payload.description,
        payout_email=payload.payout_email,
        payout_method=payload.payout_method,
        api_key=api_key,
        api_secret=api_secret,
        created_at=datetime.utcnow(),
        updated_at=datetime.utcnow(),
    )
    db.add(publisher)
    db.commit()
    db.refresh(publisher)
    return publisher


@router.get("/publishers/{publisher_id}", response_model=PublisherResponse)
def get_publisher(publisher_id: int, db: Session = Depends(get_db)):
    """Get publisher details"""
    publisher = db.query(Publisher).filter(Publisher.id == publisher_id).first()
    if not publisher:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Publisher not found")
    return publisher


@router.put("/publishers/{publisher_id}", response_model=PublisherResponse)
def update_publisher(
    publisher_id: int,
    payload: PublisherUpdateRequest,
    db: Session = Depends(get_db),
):
    """Update publisher details"""
    publisher = db.query(Publisher).filter(Publisher.id == publisher_id).first()
    if not publisher:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Publisher not found")

    if payload.company_name:
        publisher.company_name = payload.company_name
    if payload.website:
        publisher.website = payload.website
    if payload.description is not None:
        publisher.description = payload.description
    if payload.minimum_payout is not None:
        publisher.minimum_payout = payload.minimum_payout
    if payload.payout_method:
        publisher.payout_method = payload.payout_method

    publisher.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(publisher)
    return publisher


# ========== PUBLISHER APP ENDPOINTS ==========

@router.post("/publisher-apps", response_model=PublisherAppResponse)
def create_publisher_app(
    payload: PublisherAppCreateRequest,
    x_api_key: str = Header(...),
    db: Session = Depends(get_db),
):
    """Create publisher app (requires API key)"""
    publisher = verify_api_key(x_api_key, db)

    app = PublisherApp(
        publisher_id=publisher.id,
        app_name=payload.app_name,
        app_type=payload.app_type,
        platform=payload.platform,
        category=payload.category,
        description=payload.description,
        app_store_url=payload.app_store_url,
        website_url=payload.website_url,
        total_users=payload.total_users,
        monthly_active_users=payload.monthly_active_users,
        created_at=datetime.utcnow(),
        updated_at=datetime.utcnow(),
    )
    db.add(app)
    db.commit()
    db.refresh(app)
    return app


@router.get("/publisher-apps/{app_id}", response_model=PublisherAppResponse)
def get_publisher_app(app_id: int, db: Session = Depends(get_db)):
    """Get publisher app details"""
    app = db.query(PublisherApp).filter(PublisherApp.id == app_id).first()
    if not app:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="App not found")
    return app


# ========== AD PLACEMENT ENDPOINTS ==========

@router.post("/placements", response_model=AdPlacementResponse)
def create_placement(
    payload: AdPlacementCreateRequest,
    x_api_key: str = Header(...),
    db: Session = Depends(get_db),
):
    """Create ad placement in app (requires API key)"""
    publisher = verify_api_key(x_api_key, db)

    app = db.query(PublisherApp).filter(
        PublisherApp.id == payload.app_id,
        PublisherApp.publisher_id == publisher.id,
    ).first()
    if not app:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="App not found")

    placement_code = hashlib.sha256(
        f"{app.id}{payload.placement_name}{datetime.utcnow().isoformat()}".encode()
    ).hexdigest()[:12]

    placement = AdPlacement(
        app_id=app.id,
        placement_name=payload.placement_name,
        placement_type=payload.placement_type,
        placement_size=payload.placement_size,
        placement_code=placement_code,
        minimum_bid=payload.minimum_bid,
        created_at=datetime.utcnow(),
        updated_at=datetime.utcnow(),
    )
    db.add(placement)
    db.commit()
    db.refresh(placement)
    return placement


@router.get("/placements/{placement_id}", response_model=AdPlacementResponse)
def get_placement(placement_id: int, db: Session = Depends(get_db)):
    """Get placement details"""
    placement = db.query(AdPlacement).filter(AdPlacement.id == placement_id).first()
    if not placement:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Placement not found")
    return placement


# ========== AD SERVING & TRACKING ==========

@router.post("/ads/serve", response_model=AdServeResponse)
def serve_ad(payload: AdServeRequest, db: Session = Depends(get_db)):
    """Serve ad to publisher app"""
    placement = db.query(AdPlacement).filter(
        AdPlacement.placement_code == payload.placement_code,
        AdPlacement.is_active == True,
    ).first()
    if not placement:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Placement not found or inactive")

    # Get eligible campaigns for this placement
    campaign = (
        db.query(InAppAdCampaign)
        .join(CampaignPlacement, CampaignPlacement.campaign_id == InAppAdCampaign.id)
        .filter(
            CampaignPlacement.placement_id == placement.id,
            InAppAdCampaign.status == "active",
            InAppAdCampaign.bid_amount >= placement.minimum_bid,
        )
        .order_by(InAppAdCampaign.bid_amount.desc())
        .first()
    )

    if not campaign:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No eligible campaign available",
        )

    # Log impression event
    event = AdEvent(
        campaign_id=campaign.id,
        placement_id=placement.id,
        app_id=placement.app_id,
        event_type="impression",
        user_id_hash=payload.user_id_hash,
        session_id=payload.session_id,
        device_info=payload.device,
        geo_location=payload.geo,
        user_agent=payload.user_agent,
        ip_address=payload.ip_address,
        event_timestamp=datetime.utcnow(),
        created_at=datetime.utcnow(),
    )
    db.add(event)
    db.commit()
    db.refresh(event)

    return AdServeResponse(
        campaign_id=campaign.id,
        campaign_name=campaign.campaign_name,
        ad_format=campaign.ad_format,
        title=campaign.title,
        description=campaign.description,
        destination_url=campaign.destination_url,
        call_to_action=campaign.call_to_action,
        creative_image_url=campaign.creative_image_url,
        creative_video_url=campaign.creative_video_url,
        impression_tracking_url=f"http://localhost:8000/api/v1/ads/track/impression/{event.id}",
        click_tracking_url=f"http://localhost:8000/api/v1/ads/track/click/{event.id}",
    )


@router.post("/ads/events", response_model=AdEventResponse)
def log_ad_event(payload: AdEventRequest, db: Session = Depends(get_db)):
    """Track ad event (click, conversion, install)"""
    placement = db.query(AdPlacement).filter(
        AdPlacement.placement_code == payload.placement_code
    ).first()
    if not placement:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Placement not found")

    # Calculate revenue based on campaign type and event type
    revenue = 0.0
    campaign = db.query(InAppAdCampaign).filter(InAppAdCampaign.id == payload.campaign_id).first()
    if campaign:
        if campaign.campaign_type == "cpc" and payload.event_type == "click":
            revenue = campaign.bid_amount / 100  # Convert cents to dollars
        elif campaign.campaign_type == "cpm" and payload.event_type == "impression":
            revenue = (campaign.bid_amount / 100) / 1000  # CPM per impression
        elif campaign.campaign_type == "cpa" and payload.event_type == "conversion":
            revenue = campaign.bid_amount / 100

    event = AdEvent(
        campaign_id=payload.campaign_id,
        placement_id=placement.id,
        app_id=placement.app_id,
        event_type=payload.event_type,
        user_id_hash=payload.user_id_hash,
        session_id=payload.session_id,
        device_info=payload.device,
        geo_location=payload.geo,
        user_agent=payload.user_agent,
        ip_address=payload.ip_address,
        revenue=revenue,
        event_timestamp=datetime.utcnow(),
        created_at=datetime.utcnow(),
    )
    db.add(event)
    db.commit()
    db.refresh(event)

    return AdEventResponse(
        status="ok",
        event_id=event.id,
        revenue=revenue,
    )


@router.get("/health")
def health_check():
    return {"status": "ok", "service": "ads-platform"}
