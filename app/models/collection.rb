class Collection < ApplicationRecord
  belongs_to :user
  has_many :collection_channels, dependent: :destroy
  has_many :channels, through: :collection_channels

  validates :name, presence: true

  # Analytics methods
  def average_engagement
    return 0 if channels.empty?
    channels.average(:avg_engagement_rate).to_f.round(2)
  end

  def total_reach
    channels.sum(:subscriber_count)
  end

  def total_channels
    channels.count
  end
end