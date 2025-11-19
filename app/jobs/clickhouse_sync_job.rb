class ClickhouseSyncJob < ApplicationJob
  queue_as :default
  
  def perform
    Rails.logger.info "Starting ClickHouse sync job..."
    
    # Clear existing data (for simplicity - in production you'd do incremental sync)
    clear_tables
    
    # Sync all data
    system("cd #{Rails.root} && bin/rails clickhouse:sync")
    
    Rails.logger.info "ClickHouse sync job completed"
  end
  
  private
  
  def clear_tables
    `docker exec clickhouse-server clickhouse-client --query="TRUNCATE TABLE adsensie_analytics.channels_analytics"`
    `docker exec clickhouse-server clickhouse-client --query="TRUNCATE TABLE adsensie_analytics.posts_analytics"`
  end
end
