-- Create database
CREATE DATABASE IF NOT EXISTS adsensie_analytics;

USE adsensie_analytics;

-- Channels Analytics Table
CREATE TABLE IF NOT EXISTS channels_analytics (
    id UInt64,
    telegram_id String,
    username String,
    title String,
    subscriber_count UInt32,
    avg_views UInt32,
    avg_engagement_rate Float32,
    growth_rate Float32,
    post_frequency Float32,
    created_at DateTime,
    updated_at DateTime
) ENGINE = MergeTree()
ORDER BY (created_at, id)
PARTITION BY toYYYYMM(created_at);

-- Posts Analytics Table
CREATE TABLE IF NOT EXISTS posts_analytics (
    id UInt64,
    channel_id UInt64,
    telegram_message_id String,
    views UInt32,
    forwards UInt16,
    replies UInt16,
    posted_at DateTime,
    created_at DateTime
) ENGINE = MergeTree()
ORDER BY (posted_at, channel_id, id)
PARTITION BY toYYYYMM(posted_at);

-- Engagement Metrics Materialized View
CREATE MATERIALIZED VIEW IF NOT EXISTS engagement_metrics_mv
ENGINE = SummingMergeTree()
PARTITION BY toYYYYMM(date)
ORDER BY (date, channel_id)
AS SELECT
    toDate(posted_at) as date,
    channel_id,
    count() as post_count,
    sum(views) as total_views,
    avg(views) as avg_views,
    sum(forwards) as total_forwards,
    sum(replies) as total_replies
FROM posts_analytics
GROUP BY date, channel_id;
