-- ===================================
-- ADS AGGREGATION & IN-APP AD PLATFORM
-- ===================================
-- Full production-ready schema
-- Supports: Facebook/TikTok/LinkedIn ad aggregation + In-app ad server + Telegram-style ads

-- ========== USERS & AUTHENTICATION ==========
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255),
    phone_number VARCHAR(20),
    profile_picture_url VARCHAR(255),
    user_type VARCHAR(50) NOT NULL, -- 'advertiser', 'publisher', 'admin', 'analyst'
    is_active BOOLEAN DEFAULT TRUE,
    email_verified BOOLEAN DEFAULT FALSE,
    two_factor_enabled BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    last_ip_address VARCHAR(45),
    INDEX idx_users_email (email),
    INDEX idx_users_username (username)
);

-- ===========================
-- ADVERTISER MANAGEMENT
-- ===========================
CREATE TABLE IF NOT EXISTS advertisers (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL UNIQUE,
    company_name VARCHAR(255) NOT NULL,
    company_registration_number VARCHAR(100),
    website VARCHAR(255),
    logo_url VARCHAR(255),
    banner_url VARCHAR(255),
    description TEXT,
    industry_category VARCHAR(100), -- 'retail', 'finance', 'gaming', 'saas', 'other'
    billing_email VARCHAR(255) NOT NULL,
    billing_phone VARCHAR(20),
    billing_address TEXT,
    billing_city VARCHAR(100),
    billing_country VARCHAR(100),
    billing_postal_code VARCHAR(20),
    account_balance DECIMAL(10, 2) DEFAULT 0.00,
    account_credit DECIMAL(10, 2) DEFAULT 0.00,
    total_spent DECIMAL(12, 2) DEFAULT 0.00,
    monthly_spend_limit DECIMAL(10, 2),
    daily_spend_limit DECIMAL(10, 2),
    is_verified BOOLEAN DEFAULT FALSE,
    verification_status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'approved', 'rejected', 'suspended'
    verification_documents_url VARCHAR(255),
    verification_reviewed_at TIMESTAMP,
    verification_reviewed_by INTEGER,
    is_suspended BOOLEAN DEFAULT FALSE,
    suspension_reason TEXT,
    suspension_date TIMESTAMP,
    contact_person_name VARCHAR(255),
    contact_person_email VARCHAR(255),
    contact_person_phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_advertisers_verification (verification_status),
    INDEX idx_advertisers_balance (account_balance)
);

-- ===========================
-- PUBLISHER MANAGEMENT
-- ===========================
CREATE TABLE IF NOT EXISTS publishers (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL UNIQUE,
    company_name VARCHAR(255) NOT NULL,
    company_registration_number VARCHAR(100),
    website VARCHAR(255),
    logo_url VARCHAR(255),
    description TEXT,
    api_key VARCHAR(255) UNIQUE NOT NULL,
    api_secret VARCHAR(255) NOT NULL,
    api_key_created_at TIMESTAMP,
    api_key_last_used_at TIMESTAMP,
    account_balance DECIMAL(10, 2) DEFAULT 0.00,
    total_earnings DECIMAL(12, 2) DEFAULT 0.00,
    pending_payouts DECIMAL(10, 2) DEFAULT 0.00,
    payout_method VARCHAR(50), -- 'bank_transfer', 'paypal', 'crypto', 'stripe'
    payout_email VARCHAR(255),
    payout_phone VARCHAR(20),
    payout_account_details JSON,
    minimum_payout_amount DECIMAL(10, 2) DEFAULT 100.00,
    payout_frequency VARCHAR(50) DEFAULT 'monthly', -- 'weekly', 'bi-weekly', 'monthly'
    last_payout_date TIMESTAMP,
    next_payout_date TIMESTAMP,
    is_verified BOOLEAN DEFAULT FALSE,
    verification_status VARCHAR(50) DEFAULT 'pending',
    verification_documents_url VARCHAR(255),
    is_suspended BOOLEAN DEFAULT FALSE,
    suspension_reason TEXT,
    suspension_date TIMESTAMP,
    contact_person_name VARCHAR(255),
    contact_person_email VARCHAR(255),
    contact_person_phone VARCHAR(20),
    tax_id_number VARCHAR(50),
    banking_details_verified BOOLEAN DEFAULT FALSE,
    fraud_score INTEGER DEFAULT 0,
    is_high_priority BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_publishers_api_key (api_key),
    INDEX idx_publishers_verification (verification_status),
    INDEX idx_publishers_balance (account_balance)
);

-- ===========================
-- PUBLISHER APPS & CHANNELS
-- ===========================
CREATE TABLE IF NOT EXISTS publisher_apps (
    id SERIAL PRIMARY KEY,
    publisher_id INTEGER NOT NULL,
    app_name VARCHAR(255) NOT NULL,
    app_type VARCHAR(50) NOT NULL, -- 'mobile', 'web', 'desktop', 'telegram_channel', 'tiktok_channel'
    platform VARCHAR(50) NOT NULL, -- 'ios', 'android', 'web', 'windows', 'telegram', 'tiktok'
    app_identifier VARCHAR(255), -- bundle id, package name, or channel ID
    app_store_url VARCHAR(255),
    website_url VARCHAR(255),
    telegram_channel_username VARCHAR(255),
    telegram_channel_id VARCHAR(255),
    tiktok_channel_username VARCHAR(255),
    tiktok_channel_id VARCHAR(255),
    description TEXT,
    category VARCHAR(100), -- 'news', 'gaming', 'education', 'entertainment', 'social', 'business'
    icon_url VARCHAR(255),
    banner_url VARCHAR(255),
    language VARCHAR(10) DEFAULT 'en',
    target_age_group VARCHAR(50), -- '13-18', '18-25', '25-35', '35-50', '50+'
    total_users INTEGER DEFAULT 0,
    monthly_active_users INTEGER DEFAULT 0,
    daily_active_users INTEGER DEFAULT 0,
    average_session_duration_seconds INTEGER,
    rating DECIMAL(2, 1),
    rating_count INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    verification_status VARCHAR(50) DEFAULT 'pending', -- for Telegram/TikTok channels
    verification_documents_url VARCHAR(255),
    content_moderation_status VARCHAR(50) DEFAULT 'approved',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (publisher_id) REFERENCES publishers(id) ON DELETE CASCADE,
    INDEX idx_publisher_apps_publisher (publisher_id),
    INDEX idx_publisher_apps_platform (platform),
    INDEX idx_publisher_apps_category (category),
    INDEX idx_publisher_apps_users (monthly_active_users)
);

-- ===========================
-- AD PLACEMENTS
-- ===========================
CREATE TABLE IF NOT EXISTS ad_placements (
    id SERIAL PRIMARY KEY,
    app_id INTEGER NOT NULL,
    placement_name VARCHAR(255) NOT NULL,
    placement_type VARCHAR(50) NOT NULL, -- 'banner', 'interstitial', 'rewarded', 'native', 'sponsored_message' (Telegram)
    placement_size VARCHAR(50), -- '320x50', '300x250', 'fullscreen', 'flexible'
    placement_code VARCHAR(100) UNIQUE NOT NULL,
    placement_description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    minimum_bid DECIMAL(10, 2) DEFAULT 0.10,
    expected_impressions_per_day INTEGER,
    expected_ctr DECIMAL(5, 2),
    page_url VARCHAR(255), -- for web placements
    screen_name VARCHAR(255), -- for app placements
    position_description VARCHAR(255), -- 'top', 'middle', 'bottom', 'between_posts', 'sidebar'
    supported_formats VARCHAR(255), -- comma-separated: 'image', 'video', 'text', 'native'
    viewability_target DECIMAL(5, 2), -- target viewability percentage
    blocked_advertiser_categories JSON, -- categories not allowed
    blocked_advertisers JSON, -- specific advertiser IDs not allowed
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (app_id) REFERENCES publisher_apps(id) ON DELETE CASCADE,
    INDEX idx_placements_app (app_id),
    INDEX idx_placements_code (placement_code),
    INDEX idx_placements_type (placement_type)
);

-- ===========================
-- CAMPAIGNS (Advertiser)
-- ===========================
CREATE TABLE IF NOT EXISTS in_app_ad_campaigns (
    id SERIAL PRIMARY KEY,
    advertiser_id INTEGER NOT NULL,
    campaign_name VARCHAR(255) NOT NULL,
    campaign_description TEXT,
    campaign_type VARCHAR(50) NOT NULL, -- 'cpm', 'cpc', 'cpv', 'cpa', 'cpi'
    ad_format VARCHAR(50) NOT NULL, -- 'banner', 'interstitial', 'rewarded', 'native', 'video', 'carousel', 'sponsored_message'
    title VARCHAR(255) NOT NULL,
    description TEXT,
    body_text TEXT,
    creative_image_url VARCHAR(255),
    creative_video_url VARCHAR(255),
    creative_thumbnail_url VARCHAR(255),
    destination_url VARCHAR(255) NOT NULL,
    destination_app_id VARCHAR(255), -- for app install campaigns
    call_to_action VARCHAR(100) DEFAULT 'Learn More', -- 'Learn More', 'Shop Now', 'Download', 'Sign Up', 'Install'
    daily_budget DECIMAL(10, 2),
    total_budget DECIMAL(12, 2),
    spent_budget DECIMAL(12, 2) DEFAULT 0.00,
    bid_amount DECIMAL(10, 2) NOT NULL, -- in cents
    bid_strategy VARCHAR(50) DEFAULT 'manual', -- 'manual', 'automatic', 'target_cpa', 'maximize_conversions'
    status VARCHAR(50) DEFAULT 'draft', -- 'draft', 'pending_review', 'approved', 'active', 'paused', 'completed', 'archived', 'rejected'
    status_reason TEXT, -- reason for rejection or pause
    targeting_json JSON, -- geo, demographics, interests, device, os
    exclusions_json JSON, -- negative targeting
    frequency_cap_impressions INTEGER DEFAULT 3, -- per user per day
    frequency_cap_clicks INTEGER DEFAULT 1, -- per user per day
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP,
    timezone VARCHAR(50) DEFAULT 'UTC',
    schedule_json JSON, -- day/time scheduling
    platform_specific_json JSON, -- platform-specific settings
    created_by INTEGER,
    reviewed_by INTEGER,
    review_notes TEXT,
    reviewed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (advertiser_id) REFERENCES advertisers(id) ON DELETE CASCADE,
    INDEX idx_campaigns_advertiser (advertiser_id),
    INDEX idx_campaigns_status (status),
    INDEX idx_campaigns_budget (spent_budget),
    INDEX idx_campaigns_start_date (start_date)
);

-- Campaign placements mapping
CREATE TABLE IF NOT EXISTS campaign_placements (
    id SERIAL PRIMARY KEY,
    campaign_id INTEGER NOT NULL,
    placement_id INTEGER NOT NULL,
    daily_budget DECIMAL(10, 2),
    daily_impressions_limit INTEGER,
    daily_clicks_limit INTEGER,
    status VARCHAR(50) DEFAULT 'active',
    placement_bid_override DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(campaign_id, placement_id),
    FOREIGN KEY (campaign_id) REFERENCES in_app_ad_campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (placement_id) REFERENCES ad_placements(id) ON DELETE CASCADE,
    INDEX idx_campaign_placements_campaign (campaign_id),
    INDEX idx_campaign_placements_placement (placement_id)
);

-- ===========================
-- AD EVENTS & TRACKING
-- ===========================
CREATE TABLE IF NOT EXISTS ad_events (
    id BIGSERIAL PRIMARY KEY,
    campaign_id INTEGER NOT NULL,
    placement_id INTEGER NOT NULL,
    app_id INTEGER NOT NULL,
    advertiser_id INTEGER NOT NULL,
    publisher_id INTEGER NOT NULL,
    event_type VARCHAR(50) NOT NULL, -- 'impression', 'click', 'conversion', 'install', 'view', 'engagement'
    user_id_hash VARCHAR(255), -- hashed user ID for privacy
    session_id VARCHAR(255),
    request_id VARCHAR(255), -- unique request identifier
    device_info JSON, -- {"os": "android", "version": "14", "brand": "samsung", "model": "Galaxy"}
    geo_location JSON, -- {"country": "US", "region": "CA", "city": "SF", "latitude": 37.7749, "longitude": -122.4194}
    user_agent VARCHAR(500),
    ip_address VARCHAR(45),
    referrer_url VARCHAR(255),
    conversion_value DECIMAL(10, 2),
    conversion_currency VARCHAR(10),
    install_id VARCHAR(255), -- for install tracking
    is_viewable BOOLEAN,
    viewable_duration_seconds INTEGER,
    impression_quality_score INTEGER, -- 0-100
    is_fraud BOOLEAN DEFAULT FALSE,
    fraud_score INTEGER DEFAULT 0,
    fraud_reason VARCHAR(255),
    revenue DECIMAL(10, 2) DEFAULT 0.00, -- actual revenue from this event
    publisher_revenue DECIMAL(10, 2) DEFAULT 0.00, -- revenue to publisher
    platform_fee DECIMAL(10, 2) DEFAULT 0.00, -- platform revenue
    event_timestamp TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_events_campaign (campaign_id),
    INDEX idx_events_placement (placement_id),
    INDEX idx_events_app (app_id),
    INDEX idx_events_event_type (event_type),
    INDEX idx_events_timestamp (event_timestamp),
    INDEX idx_events_advertiser (advertiser_id),
    INDEX idx_events_publisher (publisher_id),
    INDEX idx_events_fraud (is_fraud),
    INDEX idx_events_user_hash (user_id_hash)
);

-- ===========================
-- PERFORMANCE & ANALYTICS
-- ===========================
CREATE TABLE IF NOT EXISTS daily_performance (
    id SERIAL PRIMARY KEY,
    campaign_id INTEGER NOT NULL,
    placement_id INTEGER NOT NULL,
    date DATE NOT NULL,
    impressions INTEGER DEFAULT 0,
    clicks INTEGER DEFAULT 0,
    conversions INTEGER DEFAULT 0,
    installs INTEGER DEFAULT 0,
    views INTEGER DEFAULT 0,
    engagements INTEGER DEFAULT 0,
    unique_users INTEGER DEFAULT 0,
    total_spend DECIMAL(12, 2) DEFAULT 0.00, -- advertiser spend
    total_revenue DECIMAL(12, 2) DEFAULT 0.00, -- publisher revenue
    ctr DECIMAL(5, 2), -- click-through rate
    cpc DECIMAL(10, 2), -- cost per click
    cpa DECIMAL(10, 2), -- cost per action
    cpi DECIMAL(10, 2), -- cost per install
    roas DECIMAL(5, 2), -- return on ad spend
    conversion_rate DECIMAL(5, 2),
    viewability_rate DECIMAL(5, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(campaign_id, placement_id, date),
    FOREIGN KEY (campaign_id) REFERENCES in_app_ad_campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (placement_id) REFERENCES ad_placements(id) ON DELETE CASCADE,
    INDEX idx_daily_perf_date (date),
    INDEX idx_daily_perf_campaign (campaign_id)
);

-- Hourly performance for real-time dashboards
CREATE TABLE IF NOT EXISTS hourly_performance (
    id SERIAL PRIMARY KEY,
    campaign_id INTEGER NOT NULL,
    placement_id INTEGER NOT NULL,
    date_hour TIMESTAMP NOT NULL,
    impressions INTEGER DEFAULT 0,
    clicks INTEGER DEFAULT 0,
    conversions INTEGER DEFAULT 0,
    total_spend DECIMAL(12, 2) DEFAULT 0.00,
    total_revenue DECIMAL(12, 2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(campaign_id, placement_id, date_hour),
    FOREIGN KEY (campaign_id) REFERENCES in_app_ad_campaigns(id) ON DELETE CASCADE,
    INDEX idx_hourly_perf_date_hour (date_hour),
    INDEX idx_hourly_perf_campaign (campaign_id)
);

-- ===========================
-- BILLING & TRANSACTIONS
-- ===========================
CREATE TABLE IF NOT EXISTS transactions (
    id SERIAL PRIMARY KEY,
    advertiser_id INTEGER,
    publisher_id INTEGER,
    transaction_type VARCHAR(50) NOT NULL, -- 'charge', 'credit', 'refund', 'payout', 'adjustment'
    amount DECIMAL(12, 2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'USD',
    related_event_id BIGINT, -- link to ad_events
    related_campaign_id INTEGER,
    payment_method VARCHAR(50), -- 'credit_card', 'wire_transfer', 'crypto', 'paypal'
    status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'completed', 'failed', 'reversed'
    status_reason VARCHAR(255),
    description VARCHAR(255),
    invoice_number VARCHAR(100),
    reference_id VARCHAR(255),
    metadata JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    INDEX idx_transactions_advertiser (advertiser_id),
    INDEX idx_transactions_publisher (publisher_id),
    INDEX idx_transactions_status (status),
    INDEX idx_transactions_created (created_at)
);

-- Advertiser billing invoice
CREATE TABLE IF NOT EXISTS advertiser_invoices (
    id SERIAL PRIMARY KEY,
    advertiser_id INTEGER NOT NULL,
    invoice_number VARCHAR(100) UNIQUE NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    total_amount DECIMAL(12, 2) NOT NULL,
    tax_amount DECIMAL(12, 2) DEFAULT 0.00,
    discount_amount DECIMAL(12, 2) DEFAULT 0.00,
    final_amount DECIMAL(12, 2) NOT NULL,
    status VARCHAR(50) DEFAULT 'draft', -- 'draft', 'sent', 'paid', 'overdue'
    payment_date TIMESTAMP,
    due_date DATE,
    pdf_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (advertiser_id) REFERENCES advertisers(id) ON DELETE CASCADE,
    INDEX idx_invoices_advertiser (advertiser_id),
    INDEX idx_invoices_status (status)
);

-- Publisher payout records
CREATE TABLE IF NOT EXISTS publisher_payouts (
    id SERIAL PRIMARY KEY,
    publisher_id INTEGER NOT NULL,
    payout_number VARCHAR(100) UNIQUE NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    total_earnings DECIMAL(12, 2) NOT NULL,
    platform_fees DECIMAL(12, 2) DEFAULT 0.00,
    tax_withheld DECIMAL(12, 2) DEFAULT 0.00,
    payout_amount DECIMAL(12, 2) NOT NULL,
    payout_method VARCHAR(50) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'processing', 'completed', 'failed'
    status_reason TEXT,
    transaction_id VARCHAR(255),
    reference_id VARCHAR(255),
    payment_date TIMESTAMP,
    pdf_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (publisher_id) REFERENCES publishers(id) ON DELETE CASCADE,
    INDEX idx_payouts_publisher (publisher_id),
    INDEX idx_payouts_status (status),
    INDEX idx_payouts_date (payment_date)
);

-- ===========================
-- FRAUD DETECTION & COMPLIANCE
-- ===========================
CREATE TABLE IF NOT EXISTS fraud_detection_logs (
    id SERIAL PRIMARY KEY,
    event_id BIGINT,
    campaign_id INTEGER,
    placement_id INTEGER,
    fraud_type VARCHAR(100), -- 'click_fraud', 'impression_fraud', 'bot_traffic', 'invalid_conversion', 'geo_mismatch'
    fraud_score INTEGER,
    fraud_indicators JSON,
    detection_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action_taken VARCHAR(50), -- 'flagged', 'disabled_placement', 'suspended_campaign', 'blocked_ip'
    manual_review BOOLEAN DEFAULT FALSE,
    reviewed_by INTEGER,
    review_notes TEXT,
    FOREIGN KEY (event_id) REFERENCES ad_events(id) ON DELETE CASCADE,
    INDEX idx_fraud_campaign (campaign_id),
    INDEX idx_fraud_timestamp (detection_timestamp)
);

-- IP blocklist for fraud prevention
CREATE TABLE IF NOT EXISTS ip_blocklist (
    id SERIAL PRIMARY KEY,
    ip_address VARCHAR(45) NOT NULL,
    ip_range_start VARCHAR(45),
    ip_range_end VARCHAR(45),
    reason VARCHAR(255),
    fraud_incidents INTEGER DEFAULT 0,
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    UNIQUE(ip_address)
);

-- ===========================
-- CONTENT LIBRARY & CREATIVES
-- ===========================
CREATE TABLE IF NOT EXISTS ad_creatives (
    id SERIAL PRIMARY KEY,
    advertiser_id INTEGER NOT NULL,
    creative_name VARCHAR(255) NOT NULL,
    creative_type VARCHAR(50), -- 'image', 'video', 'html', 'carousel', 'native'
    file_url VARCHAR(255),
    file_size INTEGER,
    file_format VARCHAR(20), -- 'jpg', 'png', 'gif', 'mp4', 'webm', 'html'
    width INTEGER,
    height INTEGER,
    duration_seconds INTEGER, -- for videos
    thumbnail_url VARCHAR(255),
    text_content TEXT,
    headline VARCHAR(255),
    description TEXT,
    cta_text VARCHAR(100),
    status VARCHAR(50) DEFAULT 'draft', -- 'draft', 'submitted', 'approved', 'rejected', 'archived'
    approval_status VARCHAR(50) DEFAULT 'pending',
    rejection_reason TEXT,
    approved_at TIMESTAMP,
    approved_by INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (advertiser_id) REFERENCES advertisers(id) ON DELETE CASCADE,
    INDEX idx_creatives_advertiser (advertiser_id),
    INDEX idx_creatives_status (status)
);

-- ===========================
-- TELEGRAM-STYLE ADS (SPONSORED MESSAGES)
-- ===========================
CREATE TABLE IF NOT EXISTS telegram_sponsored_campaigns (
    id SERIAL PRIMARY KEY,
    advertiser_id INTEGER NOT NULL,
    campaign_name VARCHAR(255) NOT NULL,
    message_text VARCHAR(500) NOT NULL, -- max 160 chars like Telegram
    destination_url VARCHAR(255) NOT NULL,
    target_channel_id VARCHAR(255), -- specific Telegram channel
    target_channels JSON, -- list of channel IDs or targeting criteria
    targeting_json JSON, -- language, region, audience interests
    bid_amount DECIMAL(10, 2) NOT NULL, -- CPM bid
    daily_budget DECIMAL(10, 2),
    total_budget DECIMAL(12, 2),
    spent_budget DECIMAL(12, 2) DEFAULT 0.00,
    impressions_target INTEGER,
    status VARCHAR(50) DEFAULT 'draft', -- 'draft', 'pending_approval', 'approved', 'active', 'paused', 'completed'
    placement_type VARCHAR(50) DEFAULT 'after_latest_message', -- 'after_latest_message', 'between_posts', 'sidebar'
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (advertiser_id) REFERENCES advertisers(id) ON DELETE CASCADE,
    INDEX idx_telegram_campaigns_advertiser (advertiser_id),
    INDEX idx_telegram_campaigns_status (status)
);

-- Telegram message impressions
CREATE TABLE IF NOT EXISTS telegram_message_impressions (
    id BIGSERIAL PRIMARY KEY,
    campaign_id INTEGER NOT NULL,
    channel_id VARCHAR(255) NOT NULL,
    channel_username VARCHAR(255),
    message_id VARCHAR(255),
    user_id_hash VARCHAR(255),
    event_type VARCHAR(50), -- 'impression', 'click', 'forward', 'reaction'
    user_action VARCHAR(50), -- 'clicked', 'forwarded', 'reaction_added'
    reaction_type VARCHAR(50), -- emoji reaction
    event_timestamp TIMESTAMP NOT NULL,
    revenue DECIMAL(10, 2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_telegram_impressions_campaign (campaign_id),
    INDEX idx_telegram_impressions_channel (channel_id),
    INDEX idx_telegram_impressions_timestamp (event_timestamp)
);

-- ===========================
-- SOCIAL MEDIA AD AGGREGATION
-- ===========================
CREATE TABLE IF NOT EXISTS social_ad_accounts (
    id SERIAL PRIMARY KEY,
    advertiser_id INTEGER NOT NULL,
    platform VARCHAR(50) NOT NULL, -- 'facebook', 'tiktok', 'linkedin', 'google_ads', 'instagram'
    platform_account_id VARCHAR(255) NOT NULL,
    platform_account_name VARCHAR(255),
    access_token TEXT,
    refresh_token TEXT,
    token_expires_at TIMESTAMP,
    account_balance DECIMAL(12, 2),
    is_active BOOLEAN DEFAULT TRUE,
    is_connected BOOLEAN DEFAULT TRUE,
    last_sync_at TIMESTAMP,
    sync_status VARCHAR(50), -- 'syncing', 'synced', 'failed'
    sync_error TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(advertiser_id, platform, platform_account_id),
    FOREIGN KEY (advertiser_id) REFERENCES advertisers(id) ON DELETE CASCADE,
    INDEX idx_social_accounts_platform (platform),
    INDEX idx_social_accounts_advertiser (advertiser_id)
);

-- Social media ads cache
CREATE TABLE IF NOT EXISTS social_media_ads (
    id SERIAL PRIMARY KEY,
    advertiser_id INTEGER,
    social_account_id INTEGER,
    platform VARCHAR(50) NOT NULL,
    platform_ad_id VARCHAR(255) NOT NULL,
    campaign_id VARCHAR(255),
    campaign_name VARCHAR(255),
    ad_set_id VARCHAR(255),
    ad_set_name VARCHAR(255),
    ad_name VARCHAR(255) NOT NULL,
    ad_copy TEXT,
    creative_url VARCHAR(255),
    destination_url VARCHAR(255),
    ad_format VARCHAR(100),
    status VARCHAR(50),
    impressions INTEGER DEFAULT 0,
    clicks INTEGER DEFAULT 0,
    spend DECIMAL(12, 2) DEFAULT 0.00,
    conversions INTEGER DEFAULT 0,
    ctr DECIMAL(5, 2),
    cpc DECIMAL(10, 2),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    synced_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    raw_data JSON,
    UNIQUE(platform, platform_ad_id),
    INDEX idx_social_ads_platform (platform),
    INDEX idx_social_ads_advertiser (advertiser_id)
);

-- ===========================
-- AUDIENCE & TARGETING
-- ===========================
CREATE TABLE IF NOT EXISTS audience_segments (
    id SERIAL PRIMARY KEY,
    advertiser_id INTEGER NOT NULL,
    segment_name VARCHAR(255) NOT NULL,
    segment_description TEXT,
    segment_type VARCHAR(50), -- 'demographic', 'interest', 'behavioral', 'geographic', 'lookalike'
    criteria_json JSON, -- targeting criteria
    size_estimate INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (advertiser_id) REFERENCES advertisers(id) ON DELETE CASCADE
);

-- ===========================
-- AUDIT & COMPLIANCE
-- ===========================
CREATE TABLE IF NOT EXISTS audit_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER,
    action VARCHAR(255) NOT NULL,
    resource_type VARCHAR(100),
    resource_id INTEGER,
    old_values JSON,
    new_values JSON,
    changes JSONB,
    ip_address VARCHAR(45),
    user_agent VARCHAR(500),
    status VARCHAR(50), -- 'success', 'failure'
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_audit_user (user_id),
    INDEX idx_audit_created (created_at),
    INDEX idx_audit_resource (resource_type, resource_id)
);

-- ===========================
-- NOTIFICATIONS & ALERTS
-- ===========================
CREATE TABLE IF NOT EXISTS notifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    notification_type VARCHAR(100),
    title VARCHAR(255),
    message TEXT,
    related_resource_type VARCHAR(100),
    related_resource_id INTEGER,
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_notifications_user (user_id),
    INDEX idx_notifications_is_read (is_read)
);

-- ===========================
-- SUPPORT & HELP
-- ===========================
CREATE TABLE IF NOT EXISTS support_tickets (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    subject VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(100),
    priority VARCHAR(50) DEFAULT 'normal', -- 'low', 'normal', 'high', 'urgent'
    status VARCHAR(50) DEFAULT 'open', -- 'open', 'in_progress', 'resolved', 'closed'
    assigned_to INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_tickets_user (user_id),
    INDEX idx_tickets_status (status)
);

-- ===========================
-- INDEXES FOR PERFORMANCE
-- ===========================
CREATE INDEX idx_campaigns_end_date ON in_app_ad_campaigns(end_date);
CREATE INDEX idx_events_created_at ON ad_events(created_at DESC);
CREATE INDEX idx_daily_perf_created_at ON daily_performance(created_at DESC);
CREATE INDEX idx_transactions_created_at ON transactions(created_at DESC);
CREATE INDEX idx_audit_created_at ON audit_logs(created_at DESC);

-- ===========================
-- MATERIALIZED VIEWS FOR ANALYTICS
-- ===========================
CREATE VIEW campaign_summary AS
SELECT 
    c.id,
    c.advertiser_id,
    c.campaign_name,
    c.status,
    c.total_budget,
    c.spent_budget,
    COALESCE(SUM(CASE WHEN ae.event_type = 'impression' THEN 1 ELSE 0 END), 0) as total_impressions,
    COALESCE(SUM(CASE WHEN ae.event_type = 'click' THEN 1 ELSE 0 END), 0) as total_clicks,
    COALESCE(SUM(CASE WHEN ae.event_type = 'conversion' THEN 1 ELSE 0 END), 0) as total_conversions,
    c.created_at,
    c.start_date,
    c.end_date
FROM in_app_ad_campaigns c
LEFT JOIN ad_events ae ON c.id = ae.campaign_id
GROUP BY c.id, c.advertiser_id, c.campaign_name, c.status, c.total_budget, c.spent_budget, c.created_at, c.start_date, c.end_date;

CREATE VIEW publisher_summary AS
SELECT
    p.id,
    p.company_name,
    COUNT(DISTINCT pa.id) as total_apps,
    COUNT(DISTINCT ap.id) as total_placements,
    COALESCE(SUM(CASE WHEN ae.event_type = 'impression' THEN 1 ELSE 0 END), 0) as total_impressions,
    COALESCE(SUM(ae.publisher_revenue), 0) as total_revenue,
    p.account_balance,
    p.total_earnings
FROM publishers p
LEFT JOIN publisher_apps pa ON p.id = pa.publisher_id
LEFT JOIN ad_placements ap ON pa.id = ap.app_id
LEFT JOIN ad_events ae ON ap.id = ae.placement_id
GROUP BY p.id, p.company_name, p.account_balance, p.total_earnings;

CREATE VIEW advertiser_summary AS
SELECT
    a.id,
    a.company_name,
    COUNT(DISTINCT c.id) as total_campaigns,
    COUNT(DISTINCT ae.id) as total_events,
    COALESCE(SUM(ae.revenue), 0) as total_spend,
    a.account_balance
FROM advertisers a
LEFT JOIN in_app_ad_campaigns c ON a.id = c.advertiser_id
LEFT JOIN ad_events ae ON c.id = ae.campaign_id
GROUP BY a.id, a.company_name, a.account_balance;
