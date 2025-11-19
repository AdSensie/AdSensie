class ChannelsController < ApplicationController
  before_action :authenticate_user!

  def index
    @channels = Channel.all
    
    # Search
    if params[:query].present?
      @channels = @channels.search(params[:query])
    end
    
    # Filters
    if params[:min_subscribers].present? && params[:max_subscribers].present?
      @channels = @channels.by_subscribers(params[:min_subscribers].to_i, params[:max_subscribers].to_i)
    end
    
    if params[:min_engagement].present?
      @channels = @channels.by_engagement(params[:min_engagement].to_f)
    end
    
    if params[:growth_filter] == "trending"
      @channels = @channels.fast_growing
    end
    
    # Sorting
    case params[:sort]
    when "engagement"
      @channels = @channels.by_engagement_rate
    when "subscribers"
      @channels = @channels.by_subscribers
    when "growth"
      @channels = @channels.by_growth
    when "activity"
      @channels = @channels.by_activity
    else
      @channels = @channels.by_engagement_rate
    end
    
    # Simple pagination (20 per page)
    @channels = @channels.page(params[:page]).per(20)
  end

  def show
    @channel = Channel.find(params[:id])
    @recent_posts = @channel.posts.recent.limit(10)
    @collections = current_user.collections
  end

  def compare
    if params[:channel_ids].present?
      @channels = Channel.where(id: params[:channel_ids])
    else
      @channels = []
    end
  end
end
