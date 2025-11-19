class PerformanceController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @benchmarks = {}
    
    # Benchmark engagement trend
    @benchmarks[:engagement_trend] = AnalyticsService.benchmark(:engagement_trend, 30)
    
    # Benchmark posting activity
    @benchmarks[:posting_activity] = AnalyticsService.benchmark(:posting_activity, 7)
    
    # Database sizes
    @pg_size = ActiveRecord::Base.connection.execute("
      SELECT pg_size_pretty(pg_database_size('#{ActiveRecord::Base.connection.current_database}'))
    ").first['pg_size_pretty']
    
    @ch_size = `docker exec clickhouse-server clickhouse-client --query="
      SELECT formatReadableSize(sum(bytes)) FROM system.parts 
      WHERE database = 'adsensie_analytics'
    "`.strip
  end
end
