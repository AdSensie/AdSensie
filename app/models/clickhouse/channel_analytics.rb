module Clickhouse
  class ChannelAnalytics < Base
    self.table_name = 'channels_analytics'
    
    # ClickHouse doesn't support traditional ActiveRecord associations
    # Use raw SQL joins instead
  end
end
