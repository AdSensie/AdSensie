class Post < ApplicationRecord
  belongs_to :channel

  validates :telegram_message_id, presence: true
  validates :posted_at, presence: true

  scope :recent, -> { order(posted_at: :desc) }
  scope :popular, -> { order(views: :desc) }
end