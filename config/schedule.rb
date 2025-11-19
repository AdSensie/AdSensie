# Schedule ClickHouse sync every 10 minutes
every 10.minutes do
  runner "ClickhouseSyncJob.perform_later"
end
