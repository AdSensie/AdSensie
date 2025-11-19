class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    # Basic stats from ClickHouse
    stats = AnalyticsService.channel_stats
    @total_channels = stats[:total_channels]
    @avg_engagement = stats[:avg_engagement]
    @total_collections = current_user.collections.count
    
    # Top channels (still from PostgreSQL for now)
    @trending_channels = Channel.fast_growing.limit(5)
    @high_engagement_channels = Channel.high_engagement.limit(5)
    @recent_collections = current_user.collections.order(created_at: :desc).limit(5)
    
    # Analytics data from ClickHouse (much faster!)
    @engagement_trend = AnalyticsService.engagement_trend(30)
    @posting_activity = AnalyticsService.posting_activity(7)
    @top_posts = AnalyticsService.top_posts(10)
  end

  def sync
    TelegramSyncJob.perform_later
    
    respond_to do |format|
      format.html { redirect_to dashboard_path, notice: "Telegram sync started in the background." }
      format.json { render json: { message: "Sync started" }, status: :ok }
      format.turbo_stream
    end
  end
end
