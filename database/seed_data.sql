-- Insert sample data for testing

-- Users
INSERT INTO users (username, email, password_hash, full_name, user_type) VALUES
('brand_acme', 'advertiser@acme.com', 'hashed_password_1', 'John Advertiser', 'advertiser'),
('news_flow', 'publisher@newsflow.app', 'hashed_password_2', 'Jane Publisher', 'publisher'),
('admin_user', 'admin@platform.com', 'hashed_password_admin', 'Admin User', 'admin');

-- Advertisers
INSERT INTO advertisers (user_id, company_name, website, billing_email, verification_status) VALUES
(1, 'Acme Inc', 'https://acme.com', 'billing@acme.com', 'approved');

-- Publishers
INSERT INTO publishers (user_id, company_name, api_key, api_secret, verification_status) VALUES
(2, 'NewsFlow', 'pk_test_abc123def456', 'sk_test_secret123', 'approved');

-- Publisher Apps
INSERT INTO publisher_apps (publisher_id, app_name, app_type, platform, category, monthly_active_users) VALUES
(1, 'NewsFlow Mobile', 'mobile', 'android', 'news', 100000),
(1, 'NewsFlow Web', 'web', 'web', 'news', 250000);

-- Ad Placements
INSERT INTO ad_placements (app_id, placement_name, placement_type, placement_size, placement_code, minimum_bid) VALUES
(1, 'NewsFlow Home Banner', 'banner', '320x50', 'nf_home_banner_001', 0.25),
(1, 'NewsFlow Interstitial', 'interstitial', 'fullscreen', 'nf_interstitial_001', 0.50),
(2, 'NewsFlow Web Sidebar', 'banner', '300x250', 'nf_web_sidebar_001', 0.20);

-- Campaigns
INSERT INTO in_app_ad_campaigns (
    advertiser_id, campaign_name, campaign_type, ad_format, title, description,
    destination_url, daily_budget, total_budget, bid_amount, start_date, status
) VALUES
(1, 'Spring Sale 2025', 'cpc', 'banner', 'Amazing Spring Deals', 'Get 50% off everything',
'https://acme.com/spring-sale', 50.00, 500.00, 1.50, NOW(), 'active'),
(1, 'Brand Awareness', 'cpm', 'interstitial', 'Discover Acme', 'Quality Products for You',
'https://acme.com', 100.00, 1000.00, 5.00, NOW(), 'active');

-- Campaign Placements
INSERT INTO campaign_placements (campaign_id, placement_id, daily_budget) VALUES
(1, 1, 25.00),
(1, 3, 25.00),
(2, 2, 100.00);
