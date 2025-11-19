class AddAnalyticsIndexes < ActiveRecord::Migration[8.0]
  def change
    # Indexes for time-series queries on posts
    add_index :posts, [:channel_id, :posted_at], name: 'index_posts_on_channel_and_posted_at'
    add_index :posts, [:posted_at, :views], name: 'index_posts_on_posted_at_and_views'
    
    # Indexes for channel rankings and sorting
    add_index :channels, :subscriber_count, name: 'index_channels_on_subscribers'
    add_index :channels, :avg_engagement_rate, name: 'index_channels_on_engagement'
    add_index :channels, :growth_rate, name: 'index_channels_on_growth'
    
    # Composite index for top posts queries
    add_index :posts, [:channel_id, :views], name: 'index_posts_on_channel_and_views'
    
    # Index for date-based filtering
    add_index :posts, :posted_at, name: 'index_posts_on_posted_at'
    add_index :channels, :created_at, name: 'index_channels_on_created_at'
  end
end
