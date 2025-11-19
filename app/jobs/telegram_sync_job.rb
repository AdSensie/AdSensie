class TelegramSyncJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.info "Starting Telegram Sync Job..."
    
    # Broadcast start state (Syncing...)
    Turbo::StreamsChannel.broadcast_replace_to(
      "dashboard_sync",
      target: "sync_button_container",
      partial: "dashboard/sync_button",
      locals: { state: :syncing }
    )
    
    # Run the rake task to fetch and import data
    success = system("bin/rails telegram:fetch_and_import")
    
    if success
      Rails.logger.info "Telegram Sync Job completed successfully."
      
      # Broadcast finish state (Sync Now) + Toast
      Turbo::StreamsChannel.broadcast_replace_to(
        "dashboard_sync",
        target: "sync_button_container",
        partial: "dashboard/sync_button",
        locals: { state: :idle }
      )
      
      Turbo::StreamsChannel.broadcast_append_to(
        "dashboard_sync",
        target: "toast_container",
        partial: "shared/toast",
        locals: { message: "Sync Complete. Data is up to date." }
      )
    else
      Rails.logger.error "Telegram Sync Job failed."
      
      # Reset button state even on failure
      Turbo::StreamsChannel.broadcast_replace_to(
        "dashboard_sync",
        target: "sync_button_container",
        partial: "dashboard/sync_button",
        locals: { state: :idle }
      )
      
      raise "Telegram Sync Job failed to execute."
    end
  end
end
