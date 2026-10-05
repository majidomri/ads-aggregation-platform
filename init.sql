-- Aggregation Platform Tables

-- Users/Accounts Table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255),
    role VARCHAR(50) DEFAULT 'user', -- admin, advertiser, publisher
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
);

-- Connected Ad Accounts (Facebook, TikTok, LinkedIn)
CREATE TABLE IF NOT EXISTS ad_accounts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    platform VARCHAR(50) NOT NULL, -- 'facebook', 'tiktok', 'linkedin'
    account_id VARCHAR(255) NOT NULL,
    account_name VARCHAR(255),
    access_token TEXT NOT NULL,
    refresh_token TEXT,
    token_expires_at TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, platform, account_id)
);

-- Cached Ads Data (from Facebook, TikTok, LinkedIn)
CREATE TABLE IF NOT EXISTS ads (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    ad_account_id INTEGER NOT NULL REFERENCES ad_accounts(id) ON DELETE CASCADE,
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
    ad_format VARCHAR(100), -- 'image', 'video', 'carousel', 'text', 'story'
    status VARCHAR(50), -- 'active', 'paused', 'archived', 'rejected'
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    synced_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    raw_data JSONB, -- Store full API response
    UNIQUE(platform, platform_ad_id)
);

-- Ad Performance Metrics
CREATE TABLE IF NOT EXISTS ad_metrics (
    id SERIAL PRIMARY KEY,
    ad_id INTEGER NOT NULL REFERENCES ads(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    impressions INTEGER DEFAULT 0,
    clicks INTEGER DEFAULT 0,
    spend DECIMAL(10, 2) DEFAULT 0.00,
    conversions INTEGER DEFAULT 0,
    conversion_value DECIMAL(10, 2) DEFAULT 0.00,
    ctr DECIMAL(5, 2), -- Click-through rate
    cpc DECIMAL(10, 2), -- Cost per click
    cpa DECIMAL(10, 2), -- Cost per action
    roas DECIMAL(5, 2), -- Return on ad spend
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(ad_id, date)
);

-- Search/Saved Ads
CREATE TABLE IF NOT EXISTS saved_ads (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    ad_id INTEGER NOT NULL REFERENCES ads(id) ON DELETE CASCADE,
    notes TEXT,
    tags VARCHAR(255)[],
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Ad Collections (for organizing research)
CREATE TABLE IF NOT EXISTS ad_collections (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    is_public BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS collection_ads (
    collection_id INTEGER NOT NULL REFERENCES ad_collections(id) ON DELETE CASCADE,
    ad_id INTEGER NOT NULL REFERENCES ads(id) ON DELETE CASCADE,
    PRIMARY KEY(collection_id, ad_id)
);

-- ===== IN-APP ADS SYSTEM =====

-- Publishers (app owners)
CREATE TABLE IF NOT EXISTS publishers (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    company_name VARCHAR(255) NOT NULL,
    description TEXT,
    website VARCHAR(255),
    api_key VARCHAR(255) UNIQUE NOT NULL,
    is_verified BOOLEAN DEFAULT FALSE,
    balance DECIMAL(10, 2) DEFAULT 0.00,
    payout_method VARCHAR(50), -- 'bank_transfer', 'paypal', 'cryptocurrency'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Publisher Apps/Channels
CREATE TABLE IF NOT EXISTS publisher_apps (
    id SERIAL PRIMARY KEY,
    publisher_id INTEGER NOT NULL REFERENCES publishers(id) ON DELETE CASCADE,
    app_name VARCHAR(255) NOT NULL,
    app_type VARCHAR(50), -- 'mobile', 'web', 'desktop'
    platform VARCHAR(50), -- 'ios', 'android', 'web'
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    total_users INTEGER DEFAULT 0,
    monthly_active_users INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Ad Placements (slots in apps)
CREATE TABLE IF NOT EXISTS ad_placements (
    id SERIAL PRIMARY KEY,
    app_id INTEGER NOT NULL REFERENCES publisher_apps(id) ON DELETE CASCADE,
    placement_name VARCHAR(255) NOT NULL,
    placement_type VARCHAR(50), -- 'banner', 'interstitial', 'rewarded', 'native'
    placement_size VARCHAR(50), -- '320x50', '300x250', 'fullscreen'
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- In-App Ad Campaigns (advertisers)
CREATE TABLE IF NOT EXISTS in_app_ad_campaigns (
    id SERIAL PRIMARY KEY,
    advertiser_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    campaign_name VARCHAR(255) NOT NULL,
    campaign_type VARCHAR(50), -- 'cpm', 'cpc', 'cpv', 'cpa'
    ad_format VARCHAR(50), -- 'banner', 'interstitial', 'rewarded', 'native'
    title VARCHAR(255),
    description TEXT,
    creative_image_url VARCHAR(255),
    creative_video_url VARCHAR(255),
    destination_url VARCHAR(255),
    daily_budget DECIMAL(10, 2),
    total_budget DECIMAL(10, 2),
    bid_amount DECIMAL(10, 2),
    status VARCHAR(50) DEFAULT 'draft', -- 'draft', 'active', 'paused', 'completed', 'rejected'
    targeting_json JSONB, -- Geographic, demographic, interest targeting
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- In-App Ad Placements for Campaigns
CREATE TABLE IF NOT EXISTS campaign_placements (
    id SERIAL PRIMARY KEY,
    campaign_id INTEGER NOT NULL REFERENCES in_app_ad_campaigns(id) ON DELETE CASCADE,
    placement_id INTEGER NOT NULL REFERENCES ad_placements(id) ON DELETE CASCADE,
    daily_budget DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(campaign_id, placement_id)
);

-- In-App Ad Events (impressions, clicks, conversions)
CREATE TABLE IF NOT EXISTS ad_events (
    id SERIAL PRIMARY KEY,
    campaign_id INTEGER NOT NULL REFERENCES in_app_ad_campaigns(id) ON DELETE CASCADE,
    placement_id INTEGER NOT NULL REFERENCES ad_placements(id) ON DELETE CASCADE,
    event_type VARCHAR(50), -- 'impression', 'click', 'conversion', 'install'
    user_id_hash VARCHAR(255), -- Hashed user ID for privacy
    device_info JSONB, -- device type, OS, app version
    geo_location JSONB, -- country, region, city
    event_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    revenue DECIMAL(10, 2) DEFAULT 0.00
);

-- In-App Ad Performance (aggregated)
CREATE TABLE IF NOT EXISTS in_app_ad_performance (
    id SERIAL PRIMARY KEY,
    campaign_id INTEGER NOT NULL REFERENCES in_app_ad_campaigns(id) ON DELETE CASCADE,
    placement_id INTEGER NOT NULL REFERENCES ad_placements(id),
    date DATE NOT NULL,
    impressions INTEGER DEFAULT 0,
    clicks INTEGER DEFAULT 0,
    conversions INTEGER DEFAULT 0,
    total_spend DECIMAL(10, 2) DEFAULT 0.00,
    total_revenue DECIMAL(10, 2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(campaign_id, placement_id, date)
);

-- Transactions (payouts to publishers, charges to advertisers)
CREATE TABLE IF NOT EXISTS transactions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    transaction_type VARCHAR(50), -- 'charge', 'payout', 'refund'
    amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'USD',
    description VARCHAR(255),
    status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'completed', 'failed'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Audit Log
CREATE TABLE IF NOT EXISTS audit_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER,
    action VARCHAR(255),
    resource_type VARCHAR(100),
    resource_id INTEGER,
    changes JSONB,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX idx_ads_user_id ON ads(user_id);
CREATE INDEX idx_ads_platform ON ads(platform);
CREATE INDEX idx_ads_status ON ads(status);
CREATE INDEX idx_ad_metrics_date ON ad_metrics(date);
CREATE INDEX idx_ad_events_campaign ON ad_events(campaign_id);
CREATE INDEX idx_ad_events_timestamp ON ad_events(event_timestamp);
CREATE INDEX idx_campaigns_advertiser ON in_app_ad_campaigns(advertiser_id);
CREATE INDEX idx_campaigns_status ON in_app_ad_campaigns(status);
CREATE INDEX idx_publisher_api_key ON publishers(api_key);
CREATE INDEX idx_transactions_user ON transactions(user_id);
