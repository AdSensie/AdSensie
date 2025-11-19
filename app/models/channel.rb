class Channel < ApplicationRecord
  # Associations
  has_many :posts, dependent: :destroy
  has_many :collection_channels, dependent: :destroy
  has_many :collections, through: :collection_channels

  # Validations
  validates :telegram_id, presence: true, uniqueness: true
  validates :username, presence: true
  validates :title, presence: true

  # Scopes for filtering
  scope :high_engagement, -> { where("avg_engagement_rate > ?", 5.0) }
  scope :fast_growing, -> { where("growth_rate > ?", 10.0) }
  scope :active_channels, -> { where("post_frequency > ?", 0.5) }
  scope :by_subscribers, ->(min, max) { where(subscriber_count: min..max) }
  scope :by_engagement, ->(min) { where("avg_engagement_rate >= ?", min) }

  # Search scope
  scope :search, ->(query) {
    where("title ILIKE ? OR username ILIKE ? OR description ILIKE ?",
          "%#{query}%", "%#{query}%", "%#{query}%")
  }

  # Sorting scopes
  scope :by_engagement_rate, -> { order(avg_engagement_rate: :desc) }
  scope :by_subscribers, -> { order(subscriber_count: :desc) }
  scope :by_growth, -> { order(growth_rate: :desc) }
  scope :by_activity, -> { order(post_frequency: :desc) }

  # Instance methods
  def engagement_rate
    return 0 if subscriber_count.zero?
    ((avg_views.to_f / subscriber_count) * 100).round(2)
  end

  def growth_trend
    return "stable" if growth_rate.nil? || growth_rate.zero?
    growth_rate > 10 ? "trending" : "stable"
  end

  def calculate_metrics
    return if posts.empty?

    update(
      avg_views: posts.average(:views).to_i,
      avg_engagement_rate: engagement_rate,
      post_frequency: calculate_post_frequency
    )
  end

  private

  def calculate_post_frequency
    return 0 if posts.empty?
    days = (Time.current - posts.minimum(:posted_at)).to_i / 1.day
    days.zero? ? posts.count : (posts.count.to_f / days).round(2)
  end
end
