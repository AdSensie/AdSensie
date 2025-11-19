<img width="704" height="770" alt="AdSensie" src="https://github.com/user-attachments/assets/589ef40e-519b-426f-84ea-b477bca71323" /># AdSensie - Telegram Analytics for Ad Placement


<img width="704" height="770" alt="AdSensie" src="https://github.com/user-attachments/assets/43b1b5d1-a62c-4334-90a5-44fd89f4f718" />




A Rails-based analytics platform to help advertisers identify the best Telegram channels for ad placement through data-driven metrics.

## 🎯 Features

- **Channel Discovery**: Browse and search channels
- **Advanced Filtering**: Filter by engagement rate, subscriber count, growth rate
- **Smart Sorting**: Sort by engagement, subscribers, growth, or activity
- **Collections**: Organize channels into custom lists for campaigns
- **Real-time Data**: Fetch live data from Telegram API
- **Analytics Dashboard**: View key metrics and trending channels with interactive charts
- **ClickHouse Integration**: Lightning-fast analytics queries on large datasets
- **Performance Monitoring**: Compare PostgreSQL vs ClickHouse query performance
- **Automatic Data Sync**: Scheduled syncing between PostgreSQL and ClickHouse

## 🚀 Quick Start

### Prerequisites

- Ruby 3.4.1+
- PostgreSQL
- Redis (for Sidekiq background jobs)
- Docker (for ClickHouse)
- Python 3.7+ (for Telegram data fetching)
- Telegram API credentials

### Installation

1. **Clone and setup**
   ```bash
   git clone <your-repo-url>
   cd ad_sensie
   bundle install
   ```

2. **Configure environment variables**
   
   Create a `.env` file (DO NOT commit this file):
   ```env
   # Telegram API Credentials
   # Get these from https://my.telegram.org/apps
   TELEGRAM_API_ID=your_api_id_here
   TELEGRAM_API_HASH=your_api_hash_here
   
   # Database Configuration
   DATABASE_USERNAME=postgres
   DATABASE_PASSWORD=your_secure_password
   
   # Redis URL (optional, defaults to localhost)
   REDIS_URL=redis://localhost:6379/1
   ```
   
3. **Start Services via Docker**
   
   If you don't have these services installed locally, run them with Docker:

   **PostgreSQL** (Main Database):
   ```bash
   docker run -d \
     --name postgres \
     -e POSTGRES_USER=postgres \
     -e POSTGRES_PASSWORD=password \
     -p 5432:5432 \
     postgres:16
   ```

   **Redis** (Caching & Background Jobs):
   ```bash
   docker run -d \
     --name redis \
     -p 6379:6379 \
     redis:7-alpine
   ```

   **ClickHouse** (Analytics):
   ```bash
   docker run -d \
     --name clickhouse-server \
     -p 8123:8123 -p 9000:9000 \
     --ulimit nofile=262144:262144 \
     clickhouse/clickhouse-server
   ```

4. **Configure database**
   ```bash
   bin/rails db:create db:migrate
   ```

5. **Load seed data** (optional)
   ```bash
   bin/rails db:seed
   ```

6. **Initialize ClickHouse**
   ```bash
   docker exec -i clickhouse-server clickhouse-client < db/clickhouse/schema.sql
   bin/rails clickhouse:sync
   ```



7. **Start the application**
   ```bash
   bin/dev
   ```
   
   This starts:
   - Rails server (port 3000)
   - Sidekiq (background jobs)
   - Tailwind CSS watcher

8. **Access the application**
   - Open http://localhost:3000
   - Login with: `email` / `password`

## 📡 Fetching Real Telegram Data

### Setup Telegram API

1. **Get API credentials**:
   - Visit https://my.telegram.org/apps
   - Create a new application
   - Copy your `api_id` and `api_hash`
   - Add them to your `.env` file

2. **Edit the channel list** in `lib/telegram/fetch_channels.py`:
   ```python
   channels = [
       '@EthioTechNews',
       '@DevEthiopia',
       '@EthioJobsTech',
       # Add more channels...
   ]
   ```

3. **Run the fetcher** (first time will require phone authentication):
   ```bash
   python3 lib/telegram/fetch_channels.py
   ```
   
   You'll be prompted to enter your phone number and verification code.

4. **Import data into Rails**:
   ```bash
   bin/rails telegram:import
   ```

5. **Or do both in one command**:
   ```bash
   bin/rails telegram:fetch_and_import
   ```

## 📊 Database Architecture

### PostgreSQL (Source of Truth)
- **Users**: Authentication with Devise
- **Channels**: Telegram channel information and metrics
- **Posts**: Individual channel posts with engagement data
- **Collections**: User-created channel lists
- **CollectionChannels**: Join table for collections

### ClickHouse (Analytics Engine)
- **channels_analytics**: Optimized for fast aggregations
- **posts_analytics**: Time-series partitioned by month
- **engagement_metrics_mv**: Materialized view for pre-aggregated metrics

### Data Flow
```
Telegram API → PostgreSQL → ClickHouse (every 10 min) → Dashboard
```

## 🎨 Key Pages

- `/` - Dashboard with overview and trending channels
- `/channels` - Browse all channels with search and filters
- `/channels/:id` - Channel detail page
- `/channels/compare` - Compare multiple channels side-by-side
- `/collections` - Manage your channel collections
- `/performance` - PostgreSQL vs ClickHouse performance comparison

## 🔧 Development

### Run tests
```bash
# Tests not yet implemented
```

### Rails console
```bash
bin/rails console
```

### Check routes
```bash
bin/rails routes
```

### ClickHouse queries
```bash
# Via Docker
docker exec clickhouse-server clickhouse-client --database=adsensie_analytics

# Example query
docker exec clickhouse-server clickhouse-client --query="
  SELECT toDate(posted_at) as date, COUNT(*) as posts
  FROM adsensie_analytics.posts_analytics
  WHERE posted_at >= now() - INTERVAL 7 DAY
  GROUP BY date
  ORDER BY date
"
```

## 📝 Available Rake Tasks

```bash
# Telegram data
bin/rails telegram:import              # Import from JSON
bin/rails telegram:fetch_and_import    # Fetch and import

# ClickHouse
bin/rails clickhouse:sync              # Sync all data to ClickHouse
bin/rails clickhouse:stats             # Show ClickHouse statistics

# Database
bin/rails db:reset                     # Reset and reload seed data
```

## 🗂️ Project Structure

```
ad_sensie/
├── app/
│   ├── controllers/      # Dashboard, Channels, Collections, Performance
│   ├── models/           # User, Channel, Post, Collection
│   │   └── clickhouse/   # ClickHouse models
│   ├── services/         # AnalyticsService, ClickhouseSyncService
│   ├── jobs/             # TelegramSyncJob, ClickhouseSyncJob
│   ├── views/            # ERB templates with Tailwind CSS
│   └── helpers/          # View helpers
├── lib/
│   ├── telegram/         # Python scripts for Telegram API
│   └── tasks/            # Rake tasks (telegram, clickhouse)
├── db/
│   ├── migrate/          # PostgreSQL migrations
│   ├── clickhouse/       # ClickHouse schema
│   └── seeds.rb          # Mock data generator
└── config/
    ├── routes.rb         # Application routes
    ├── database.yml      # PostgreSQL configuration
    ├── clickhouse.yml    # ClickHouse configuration
    └── schedule.rb       # Cron jobs (whenever gem)
```

## 📚 Tech Stack

- **Backend**: Ruby on Rails 8.0
- **Databases**: 
  - PostgreSQL (transactional data)
  - ClickHouse (analytics)
  - Redis (caching, Sidekiq)
- **Frontend**: Tailwind CSS, Turbo, Stimulus
- **Charts**: Chartkick + Chart.js
- **Authentication**: Devise
- **Background Jobs**: Sidekiq
- **Scheduling**: Whenever (cron)
- **Telegram API**: Telethon (Python)

## ⚡ Performance

### ClickHouse Benefits
- **10-100x faster** for analytical queries
- **10x better compression** than PostgreSQL
- **Handles billions of rows** with sub-second queries
- **Columnar storage** optimized for aggregations

### When to Use Each Database
- **PostgreSQL**: User accounts, collections, real-time updates
- **ClickHouse**: Analytics, dashboards, reports, time-series data

## 🎯 Roadmap

### Completed ✅
- [x] Channel discovery and filtering
- [x] Collections management
- [x] Analytics dashboard with charts
- [x] ClickHouse integration
- [x] Performance monitoring
- [x] Automatic data syncing

### In Progress 🚧
- [ ] Real-time sync feedback UI
- [ ] Advanced search with multiple criteria
- [ ] Date range filters

### Planned 📋
- [ ] Email reports
- [ ] CSV/PDF export
- [ ] Advanced analytics (cohort, retention)
- [ ] API endpoints
- [ ] Mobile responsive improvements
