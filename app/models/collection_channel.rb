class CollectionChannel < ApplicationRecord
  belongs_to :collection
  belongs_to :channel

  scope :ordered, -> { order(position: :asc) }
end