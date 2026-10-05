-- Full seed data for demo/testing

-- Users
INSERT INTO users (username, email, password_hash, full_name, phone, role, email_verified, created_at, updated_at) VALUES
('john_acme', 'john@acme.com', 'hashed_pwd_acme_123', 'John Smith', '+1-555-0101', 'advertiser', true, NOW(), NOW()),
('jane_newsflow', 'jane@newsflow.app', 'hashed_pwd_newsflow_123', 'Jane Doe', '+1-555-0102', 'publisher', true, NOW(), NOW()),
('bob_techstartup', 'bob@techstartup.io', 'hashed_pwd_tech_123', 'Bob Johnson', '+1-555-0103', 'advertiser', true, NOW(), NOW()),
('alice_bloggers', 'alice@bloggers.net', 'hashed_pwd_blog_123', 'Alice Chen', '+1-555-0104', 'publisher', true, NOW(), NOW()),
('charlie_gaming', 'charlie@gamingcity.app', 'hashed_pwd_gaming_123', 'Charlie Brown', '+1-555-0105', 'publisher', true, NOW(), NOW()),
('david_finance', 'david@fintech.co', 'hashed_pwd_finance_123', 'David Wilson', '+1-555-0106', 'advertiser', true, NOW(), NOW()),
('admin_user', 'admin@adplatform.com', 'hashed_pwd_admin_123', 'Admin User', '+1-555-0200', 'admin', true, NOW(), NOW());

-- Advertisers
INSERT INTO advertisers (user_id, company_name, website_url, description, billing_email, industry, account_balance, is_verified, verification_status, created_at, updated_at) VALUES
(1, 'Acme Inc', 'https://acme.com', 'E-commerce and retail brand offering quality products', 'billing@acme.com', 'retail', 5000.00, true, 'approved', NOW(), NOW()),
(3, 'TechStartup', 'https://techstartup.io', 'SaaS platform for project management', 'finance@techstartup.io', 'saas', 2500.00, true, 'approved', NOW(), NOW()),
(6, 'FinTech Solutions', 'https://fintech.co', 'Digital payment and banking solutions', 'accounting@fintech.co', 'finance', 7500.00, true, 'approved', NOW(), NOW());

-- Publishers
INSERT INTO publishers (user_id, company_name, website_url, description, api_key, api_secret, account_balance, total_earnings, is_verified, verification_status, created_at, updated_at) VALUES
(2, 'NewsFlow', 'https://newsflow.app', 'Mobile news aggregation app with 1M+ users', 'pk_newsflow_abc123def456', 'sk_newsflow_secret_xyz789', 1200.50, 8750.00, true, 'approved', NOW(), NOW()),
(4, 'Bloggers Network', 'https://bloggers.net', 'Blogging platform and content network', 'pk_bloggers_123abc456def', 'sk_bloggers_secret_uvw123', 450.75, 3200.00, true, 'approved', NOW(), NOW()),
(5, 'Gaming City', 'https://gamingcity.app', 'Mobile gaming platform with casual games', 'pk_gaming_xyz789abc123', 'sk_gaming_secret_pqr456', 890.25, 5600.00, true, 'approved', NOW(), NOW());

-- Publisher Apps
INSERT INTO publisher_apps (publisher_id, app_name, app_type, platform, app_identifier, website_url, app_store_url, description, category, total_users, monthly_active_users, daily_active_users, language, is_active, created_at, updated_at) VALUES
-- NewsFlow apps
(1, 'NewsFlow Mobile', 'mobile', 'android', 'com.newsflow.android', 'https://newsflow.app', 'https://play.google.com/store/apps/details?id=com.newsflow.android', 'Breaking news, curated articles, and trending topics', 'news', 1200000, 450000, 280000, 'en', true, NOW(), NOW()),
(1, 'NewsFlow iOS', 'mobile', 'ios', 'com.newsflow.ios', 'https://newsflow.app', 'https://apps.apple.com/app/newsflow/id123456789', 'Breaking news for iPhone and iPad', 'news', 800000, 350000, 200000, 'en', true, NOW(), NOW()),
(1, 'NewsFlow Web', 'web', 'web', NULL, 'https://newsflow.app', NULL, 'Web version of NewsFlow', 'news', 2000000, 600000, 400000, 'en', true, NOW(), NOW()),
-- Bloggers Network apps
(2, 'Bloggers Community', 'mobile', 'android', 'net.bloggers.android', 'https://bloggers.net', 'https://play.google.com/store/apps/details?id=net.bloggers.android', 'Discover blogs and connect with writers', 'lifestyle', 500000, 150000, 80000, 'en', true, NOW(), NOW()),
(2, 'Bloggers Web Portal', 'web', 'web', NULL, 'https://bloggers.net', NULL, 'Blog publishing and discovery platform', 'lifestyle', 700000, 200000, 120000, 'en', true, NOW(), NOW()),
-- Gaming City apps
(3, 'Gaming City', 'mobile', 'android', 'app.gamingcity.android', 'https://gamingcity.app', 'https://play.google.com/store/apps/details?id=app.gamingcity', 'Casual mobile games and tournaments', 'gaming', 3500000, 1200000, 750000, 'en', true, NOW(), NOW()),
(3, 'Gaming City Premium', 'mobile', 'ios', 'app.gamingcity.ios', 'https://gamingcity.app', 'https://apps.apple.com/app/gamingcity/id987654321', 'Premium gaming experience on iOS', 'gaming', 2000000, 800000, 500000, 'en', true, NOW(), NOW());

-- Ad Placements
INSERT INTO ad_placements (app_id, placement_name, placement_type, placement_size, placement_code, position, minimum_bid, expected_impressions_per_day, is_active, created_at, updated_at) VALUES
-- NewsFlow Mobile placements
(1, 'NewsFlow Home Banner', 'banner', '320x50', 'nf_android_home_banner_001', 'top', 0.25, 50000, true, NOW(), NOW()),
(1, 'NewsFlow Interstitial', 'interstitial', 'fullscreen', 'nf_android_interstitial_001', 'between_posts', 0.50, 20000, true, NOW(), NOW()),
(1, 'NewsFlow Rewarded Video', 'rewarded', 'fullscreen', 'nf_android_rewarded_001', 'bottom', 2.50, 5000, true, NOW(), NOW()),
(1, 'NewsFlow Native', 'native', 'flexible', 'nf_android_native_001', 'middle', 0.75, 30000, true, NOW(), NOW()),
-- NewsFlow iOS placements
(2, 'NewsFlow iOS Home Banner', 'banner', '320x50', 'nf_ios_home_banner_001', 'top', 0.35, 40000, true, NOW(), NOW()),
(2, 'NewsFlow iOS Interstitial', 'interstitial', 'fullscreen', 'nf_ios_interstitial_001', 'between_posts', 0.60, 15000, true, NOW(), NOW()),
-- NewsFlow Web placements
(3, 'NewsFlow Web Sidebar', 'banner', '300x250', 'nf_web_sidebar_001', 'middle', 0.20, 25000, true, NOW(), NOW()),
(3, 'NewsFlow Web Header', 'banner', '970x90', 'nf_web_header_001', 'top', 0.15, 35000, true, NOW(), NOW()),
-- Bloggers Network placements
(4, 'Bloggers Android Banner', 'banner', '320x50', 'bloggers_android_banner_001', 'top', 0.15, 15000, true, NOW(), NOW()),
(4, 'Bloggers Android Interstitial', 'interstitial', 'fullscreen', 'bloggers_android_interstitial_001', 'between_posts', 0.40, 8000, true, NOW(), NOW()),
(5, 'Bloggers Web Sidebar', 'banner', '300x600', 'bloggers_web_sidebar_001', 'middle', 0.12, 12000, true, NOW(), NOW()),
-- Gaming City placements
(6, 'Gaming City Home Banner', 'banner', '320x50', 'gaming_android_home_001', 'top', 0.50, 100000, true, NOW(), NOW()),
(6, 'Gaming City Interstitial', 'interstitial', 'fullscreen', 'gaming_android_interstitial_001', 'between_games', 1.50, 30000, true, NOW(), NOW()),
(6, 'Gaming City Rewarded', 'rewarded', 'fullscreen', 'gaming_android_rewarded_001', 'game_over', 5.00, 10000, true, NOW(), NOW()),
(7, 'Gaming City iOS Banner', 'banner', '320x50', 'gaming_ios_banner_001', 'top', 0.60, 80000, true, NOW(), NOW()),
(7, 'Gaming City iOS Interstitial', 'interstitial', 'fullscreen', 'gaming_ios_interstitial_001', 'between_games', 1.75, 25000, true, NOW(), NOW());

-- Campaigns
INSERT INTO campaigns (advertiser_id, campaign_name, campaign_type, ad_format, title, description, body_text, creative_image_url, creative_video_url, destination_url, call_to_action, daily_budget, total_budget, spent_budget, bid_amount, status, frequency_cap, start_date, end_date, created_at, updated_at) VALUES
-- Acme Inc campaigns
(1, 'Spring Sale 2025', 'cpc', 'banner', 'Amazing Spring Deals', 'Get 50% off everything in our spring collection', 'Limited time offer on all items', 'https://cdn.example.com/acme_spring.jpg', NULL, 'https://acme.com/spring-sale', 'Shop Now', 100.00, 1000.00, 250.50, 1.50, 'active', 5, NOW(), NOW() + INTERVAL '30 days', NOW(), NOW()),
(1, 'Brand Awareness Campaign', 'cpm', 'interstitial', 'Discover Acme', 'Quality products for every lifestyle', 'Visit our online store for exclusive deals', NULL, 'https://cdn.example.com/acme_brand.mp4', 'https://acme.com', 'Learn More', 200.00, 2000.00, 450.75, 5.00, 'active', 3, NOW(), NOW() + INTERVAL '45 days', NOW(), NOW()),
(1, 'Mobile App Launch', 'cpi', 'banner', 'Download Acme App', 'Shop on the go with our new mobile app', 'Download and get 20% off your first order', 'https://cdn.example.com/acme_app.jpg', NULL, 'https://acme.com/app', 'Download App', 150.00, 1500.00, 100.00, 2.50, 'active', 2, NOW(), NOW() + INTERVAL '60 days', NOW(), NOW()),
-- TechStartup campaigns
(2, 'SaaS Free Trial Campaign', 'cpa', 'native', 'Try TechStartup Free', 'Start managing projects like a pro', 'Get 14 days free, no credit card required', 'https://cdn.example.com/techstartup_trial.jpg', NULL, 'https://techstartup.io/try-free', 'Start Free Trial', 120.00, 1200.00, 350.25, 3.50, 'active', 4, NOW(), NOW() + INTERVAL '30 days', NOW(), NOW()),
(2, 'Product Demo Video', 'cpv', 'video', 'See TechStartup in Action', 'Watch how TechStartup saves time', '2-minute product walkthrough video', NULL, 'https://cdn.example.com/techstartup_demo.mp4', 'https://techstartup.io/demo', 'Watch Video', 80.00, 800.00, 200.00, 0.50, 'active', 6, NOW(), NOW() + INTERVAL '30 days', NOW(), NOW()),
-- FinTech Solutions campaigns
(3, 'Banking Launch Campaign', 'cpc', 'banner', 'Open Your Account Today', 'Digital banking made simple and secure', 'Zero fees, high APY, instant transfers', 'https://cdn.example.com/fintech_bank.jpg', NULL, 'https://fintech.co/open-account', 'Open Account', 300.00, 3000.00, 800.50, 2.00, 'active', 3, NOW(), NOW() + INTERVAL '60 days', NOW(), NOW()),
(3, 'Referral Bonus Campaign', 'cpi', 'interstitial', 'Earn $50 for Each Referral', 'Invite friends and earn rewards', 'Both you and your friend get $50 bonus', 'https://cdn.example.com/fintech_referral.jpg', NULL, 'https://fintech.co/referral', 'Refer Friend', 250.00, 2500.00, 600.00, 1.75, 'paused', 2, NOW(), NOW() + INTERVAL '45 days', NOW(), NOW());

-- Campaign Placements
INSERT INTO campaign_placements (campaign_id, placement_id, daily_budget, status, created_at, updated_at) VALUES
-- Acme Spring Sale on multiple placements
(1, 1, 30.00, 'active', NOW(), NOW()),
(1, 2, 40.00, 'active', NOW(), NOW()),
(1, 4, 30.00, 'active', NOW(), NOW()),
-- Acme Brand Awareness
(2, 2, 50.00, 'active', NOW(), NOW()),
(2, 6, 50.00, 'active', NOW(), NOW()),
(2, 9, 50.00, 'active', NOW(), NOW()),
(2, 13, 50.00, 'active', NOW(), NOW()),
-- Acme Mobile App Launch
(3, 1, 40.00, 'active', NOW(), NOW()),
(3, 5, 35.00, 'active', NOW(), NOW()),
(3, 14, 35.00, 'active', NOW(), NOW()),
(3, 15, 40.00, 'active', NOW(), NOW()),
-- TechStartup SaaS Trial
(4, 4, 40.00, 'active', NOW(), NOW()),
(4, 10, 40.00, 'active', NOW(), NOW()),
(4, 11, 40.00, 'active', NOW(), NOW()),
-- TechStartup Demo Video
(5, 2, 30.00, 'active', NOW(), NOW()),
(5, 6, 30.00, 'active', NOW(), NOW()),
(5, 13, 20.00, 'active', NOW(), NOW()),
-- FinTech Banking Launch
(6, 1, 50.00, 'active', NOW(), NOW()),
(6, 5, 50.00, 'active', NOW(), NOW()),
(6, 7, 50.00, 'active', NOW(), NOW()),
(6, 8, 50.00, 'active', NOW(), NOW()),
(6, 12, 100.00, 'active', NOW(), NOW()),
-- FinTech Referral
(7, 2, 60.00, 'paused', NOW(), NOW()),
(7, 10, 60.00, 'paused', NOW(), NOW()),
(7, 14, 60.00, 'paused', NOW(), NOW());

-- Sample Ad Events (impressions, clicks, conversions)
INSERT INTO ad_events (campaign_id, placement_id, app_id, advertiser_id, publisher_id, event_type, user_id_hash, session_id, device_info, geo_location, user_agent, ip_address, conversion_value, is_fraud, fraud_score, revenue, publisher_revenue, platform_fee, event_timestamp, created_at) VALUES
-- NewsFlow impressions
(1, 1, 1, 1, 1, 'impression', 'user_hash_001', 'sess_001', '{"os": "android", "version": "14"}', '{"country": "US", "city": "New York"}', 'Mozilla/5.0', '192.168.1.1', 0, false, 0, 0.25, 0.175, 0.075, NOW() - INTERVAL '2 hours', NOW() - INTERVAL '2 hours'),
(1, 1, 1, 1, 1, 'impression', 'user_hash_002', 'sess_002', '{"os": "android", "version": "14"}', '{"country": "US", "city": "Los Angeles"}', 'Mozilla/5.0', '192.168.1.2', 0, false, 0, 0.25, 0.175, 0.075, NOW() - INTERVAL '2 hours', NOW() - INTERVAL '2 hours'),
(1, 1, 1, 1, 1, 'click', 'user_hash_003', 'sess_003', '{"os": "android", "version": "14"}', '{"country": "US", "city": "Chicago"}', 'Mozilla/5.0', '192.168.1.3', 0, false, 0, 1.50, 1.05, 0.45, NOW() - INTERVAL '1 hour', NOW() - INTERVAL '1 hour'),
(1, 1, 1, 1, 1, 'click', 'user_hash_004', 'sess_004', '{"os": "android", "version": "14"}', '{"country": "US", "city": "Houston"}', 'Mozilla/5.0', '192.168.1.4', 0, false, 0, 1.50, 1.05, 0.45, NOW() - INTERVAL '1 hour', NOW() - INTERVAL '1 hour'),
-- Gaming City impressions and rewarded
(2, 13, 6, 1, 3, 'impression', 'user_hash_005', 'sess_005', '{"os": "android", "version": "13"}', '{"country": "US", "city": "Seattle"}', 'Mozilla/5.0', '192.168.1.5', 0, false, 0, 5.00, 3.50, 1.50, NOW() - INTERVAL '30 minutes', NOW() - INTERVAL '30 minutes'),
(2, 13, 6, 1, 3, 'impression', 'user_hash_006', 'sess_006', '{"os": "android", "version": "13"}', '{"country": "US", "city": "Boston"}', 'Mozilla/5.0', '192.168.1.6', 0, false, 0, 5.00, 3.50, 1.50, NOW() - INTERVAL '30 minutes', NOW() - INTERVAL '30 minutes'),
(2, 13, 6, 1, 3, 'click', 'user_hash_007', 'sess_007', '{"os": "android", "version": "13"}', '{"country": "US", "city": "Miami"}', 'Mozilla/5.0', '192.168.1.7', 0, false, 0, 5.00, 3.50, 1.50, NOW() - INTERVAL '15 minutes', NOW() - INTERVAL '15 minutes'),
-- TechStartup conversions
(4, 4, 3, 2, 1, 'impression', 'user_hash_008', 'sess_008', '{"os": "android", "version": "14"}', '{"country": "US", "city": "San Francisco"}', 'Mozilla/5.0', '192.168.1.8', 0, false, 0, 0.75, 0.525, 0.225, NOW() - INTERVAL '4 hours', NOW() - INTERVAL '4 hours'),
(4, 4, 3, 2, 1, 'click', 'user_hash_009', 'sess_009', '{"os": "android", "version": "14"}', '{"country": "US", "city": "San Francisco"}', 'Mozilla/5.0', '192.168.1.9', 0, false, 0, 3.50, 2.45, 1.05, NOW() - INTERVAL '3 hours', NOW() - INTERVAL '3 hours'),
(4, 4, 3, 2, 1, 'conversion', 'user_hash_009', 'sess_009', '{"os": "android", "version": "14"}', '{"country": "US", "city": "San Francisco"}', 'Mozilla/5.0', '192.168.1.9', 14.99, false, 0, 3.50, 2.45, 1.05, NOW() - INTERVAL '2 hours', NOW() - INTERVAL '2 hours'),
-- FinTech campaign events
(6, 1, 1, 3, 1, 'impression', 'user_hash_010', 'sess_010', '{"os": "android", "version": "14"}', '{"country": "US", "city": "New York"}', 'Mozilla/5.0', '192.168.1.10', 0, false, 0, 2.00, 1.40, 0.60, NOW() - INTERVAL '6 hours', NOW() - INTERVAL '6 hours'),
(6, 1, 1, 3, 1, 'click', 'user_hash_011', 'sess_011', '{"os": "android", "version": "14"}', '{"country": "US", "city": "New York"}', 'Mozilla/5.0', '192.168.1.11', 0, false, 0, 2.00, 1.40, 0.60, NOW() - INTERVAL '5 hours', NOW() - INTERVAL '5 hours'),
(6, 1, 1, 3, 1, 'conversion', 'user_hash_011', 'sess_011', '{"os": "android", "version": "14"}', '{"country": "US", "city": "New York"}', 'Mozilla/5.0', '192.168.1.11', 150.00, false, 0, 2.00, 1.40, 0.60, NOW() - INTERVAL '4 hours', NOW() - INTERVAL '4 hours');

-- Daily Performance (aggregated)
INSERT INTO daily_performance (campaign_id, placement_id, date, impressions, clicks, conversions, installs, views, engagements, unique_users, total_spend, total_revenue, ctr, cpc, cpa, roas, conversion_rate, created_at, updated_at) VALUES
-- Acme Spring Sale
(1, 1, CURRENT_DATE, 250, 8, 2, 0, 250, 15, 180, 12.50, 8.75, 3.20, 1.56, 6.25, 0.70, 0.80, NOW(), NOW()),
(1, 2, CURRENT_DATE, 180, 6, 1, 0, 180, 10, 140, 9.00, 6.30, 3.33, 1.50, 9.00, 0.70, 0.56, NOW(), NOW()),
-- TechStartup Free Trial
(4, 4, CURRENT_DATE, 320, 25, 5, 0, 320, 40, 250, 8.75, 6.12, 7.81, 0.35, 1.75, 0.70, 1.56, NOW(), NOW()),
-- FinTech Banking
(6, 1, CURRENT_DATE, 400, 12, 3, 0, 400, 25, 320, 24.00, 16.80, 3.00, 2.00, 8.00, 0.70, 0.75, NOW(), NOW()),
(6, 7, CURRENT_DATE, 280, 9, 2, 0, 280, 18, 220, 18.00, 12.60, 3.21, 2.00, 9.00, 0.70, 0.71, NOW(), NOW());

-- Transactions (sample billing records)
INSERT INTO transactions (advertiser_id, publisher_id, transaction_type, amount, currency, status, description, created_at, updated_at) VALUES
(1, NULL, 'charge', 250.50, 'USD', 'completed', 'Campaign spend for Spring Sale', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day'),
(1, NULL, 'charge', 450.75, 'USD', 'completed', 'Campaign spend for Brand Awareness', NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),
(NULL, 1, 'credit', 500.00, 'USD', 'completed', 'Publisher earnings for ad impressions and clicks', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day'),
(NULL, 3, 'credit', 350.00, 'USD', 'completed', 'Publisher earnings for Gaming City', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day'),
(2, NULL, 'charge', 200.00, 'USD', 'completed', 'Campaign spend for SaaS Trial', NOW() - INTERVAL '3 hours', NOW() - INTERVAL '3 hours'),
(3, NULL, 'charge', 800.50, 'USD', 'completed', 'Campaign spend for Banking Launch', NOW() - INTERVAL '6 hours', NOW() - INTERVAL '6 hours'),
(NULL, 1, 'credit', 100.00, 'USD', 'pending', 'Pending earnings payout', NOW() - INTERVAL '10 days', NOW() - INTERVAL '10 days'),
(NULL, 1, 'payout', 1200.50, 'USD', 'completed', 'Monthly payout to NewsFlow', NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days');

-- Audit logs (sample)
INSERT INTO audit_logs (user_id, action, entity_type, entity_id, old_values, new_values, ip_address, created_at) VALUES
(1, 'CREATE_CAMPAIGN', 'campaign', 1, NULL, '{"campaign_name": "Spring Sale 2025", "status": "draft"}', '203.0.113.1', NOW() - INTERVAL '7 days'),
(1, 'UPDATE_CAMPAIGN_STATUS', 'campaign', 1, '{"status": "draft"}', '{"status": "active"}', '203.0.113.1', NOW() - INTERVAL '6 days'),
(2, 'CREATE_APP', 'publisher_app', 1, NULL, '{"app_name": "NewsFlow Mobile", "platform": "android"}', '203.0.113.2', NOW() - INTERVAL '30 days'),
(2, 'CREATE_PLACEMENT', 'ad_placement', 1, NULL, '{"placement_name": "NewsFlow Home Banner", "placement_code": "nf_android_home_banner_001"}', '203.0.113.2', NOW() - INTERVAL '29 days'),
(3, 'CREATE_CAMPAIGN', 'campaign', 4, NULL, '{"campaign_name": "SaaS Free Trial Campaign", "status": "draft"}', '203.0.113.3', NOW() - INTERVAL '10 days');

-- Notifications (sample)
INSERT INTO notifications (user_id, title, message, is_read, created_at) VALUES
(1, 'Campaign Active', 'Your campaign "Spring Sale 2025" is now active', true, NOW() - INTERVAL '6 days'),
(1, 'Budget Alert', 'Your campaign "Spring Sale 2025" has spent 25% of daily budget', false, NOW() - INTERVAL '2 hours'),
(1, 'New Click', 'Campaign received a click from New York', true, NOW() - INTERVAL '1 hour'),
(2, 'Payout Processed', 'Your monthly payout of $1,200.50 has been processed', true, NOW() - INTERVAL '5 days'),
(2, 'Placement Performance', 'NewsFlow Home Banner has 250 impressions today', false, NOW() - INTERVAL '30 minutes'),
(3, 'Campaign Created', 'Draft campaign "Banking Launch Campaign" created successfully', true, NOW() - INTERVAL '7 days'),
(3, 'Approval Needed', 'Your campaign "Banking Launch Campaign" is awaiting review', false, NOW() - INTERVAL '6 days');
