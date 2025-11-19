class AnalyticsService
  # Use ClickHouse for analytics queries (much faster!)
  
  def self.engagement_trend(days = 30)
    start_date = days.days.ago.to_date
    
    query = <<~SQL
      SELECT 
        toDate(posted_at) as date,
        round(avg(views / subscriber_count * 100), 2) as avg_engagement
      FROM posts_analytics
      JOIN channels_analytics ON posts_analytics.channel_id = channels_analytics.id
      WHERE posted_at >= '#{start_date.strftime('%Y-%m-%d')}'
        AND subscriber_count > 0
      GROUP BY date
      ORDER BY date
    SQL
    
    result = execute_clickhouse(query)
    result.map { |row| [row['date'], row['avg_engagement'].to_f] }.to_h
  end
  
  def self.posting_activity(days = 7)
    start_date = days.days.ago.to_date
    
    query = <<~SQL
      SELECT 
        toDayOfWeek(posted_at) as day_num,
        count(*) as post_count
      FROM posts_analytics
      WHERE posted_at >= '#{start_date.strftime('%Y-%m-%d')}'
      GROUP BY day_num
      ORDER BY day_num
    SQL
    
    result = execute_clickhouse(query)
    
    # Map day numbers to names
    day_names = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
    result.map { |row| [day_names[row['day_num'].to_i % 7], row['post_count'].to_i] }.to_h
  end
  
  def self.top_posts(limit = 10)
    query = <<~SQL
      SELECT 
        posts_analytics.id,
        posts_analytics.views,
        posts_analytics.forwards,
        posts_analytics.replies,
        posts_analytics.posted_at,
        channels_analytics.title as channel_title
      FROM posts_analytics
      JOIN channels_analytics ON posts_analytics.channel_id = channels_analytics.id
      ORDER BY views DESC
      LIMIT #{limit}
    SQL
    
    execute_clickhouse(query)
  end
  
  def self.channel_stats
    query = <<~SQL
      SELECT 
        count(*) as total_channels,
        round(avg(avg_engagement_rate), 2) as avg_engagement
      FROM channels_analytics
    SQL
    
    result = execute_clickhouse(query).first
    {
      total_channels: result['total_channels'].to_i,
      avg_engagement: result['avg_engagement'].to_f
    }
  end
  
  # Performance comparison helper
  def self.benchmark(method_name, *args)
    # PostgreSQL timing
    pg_start = Time.now
    pg_result = send("#{method_name}_pg", *args)
    pg_time = Time.now - pg_start
    
    # ClickHouse timing
    ch_start = Time.now
    ch_result = send(method_name, *args)
    ch_time = Time.now - ch_start
    
    {
      postgresql: { time: pg_time, result: pg_result },
      clickhouse: { time: ch_time, result: ch_result },
      speedup: (pg_time / ch_time).round(2)
    }
  end
  
  # PostgreSQL versions (for comparison)
  def self.engagement_trend_pg(days = 30)
    start_date = days.days.ago.to_date.beginning_of_day
    
    start_date.to_date.upto(Date.today).map do |date|
      avg_engagement = Post.where(posted_at: date.beginning_of_day..date.end_of_day)
                          .joins(:channel)
                          .average("CAST(posts.views AS FLOAT) / NULLIF(channels.subscriber_count, 0) * 100")
                          &.round(2) || 0
      [date.strftime("%b %d"), avg_engagement]
    end.to_h
  end
  
  def self.posting_activity_pg(days = 7)
    start_date = days.days.ago.to_date
    
    start_date.upto(Date.today).map do |date|
      count = Post.where(posted_at: date.beginning_of_day..date.end_of_day).count
      [date.strftime("%a"), count]
    end.to_h
  end
  
  private
  
  def self.execute_clickhouse(query)
    result = `docker exec clickhouse-server clickhouse-client --database=adsensie_analytics --query="#{query.gsub('"', '\"')}" --format=JSONCompact`
    
    return [] if result.empty?
    
    json = JSON.parse(result)
    return [] unless json['data']
    
    # Convert to array of hashes
    columns = json['meta'].map { |m| m['name'] }
    json['data'].map do |row|
      Hash[columns.zip(row)]
    end
  rescue => e
    Rails.logger.error "ClickHouse query failed: #{e.message}"
    []
  end
end
