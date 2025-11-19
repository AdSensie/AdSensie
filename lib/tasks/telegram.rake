# frozen_string_literal: true

namespace :telegram do
  desc "Import channel data from Telegram JSON file"
  task import: :environment do
    require 'json'
    
    json_file = Rails.root.join('telegram_data.json')
    
    unless File.exist?(json_file)
      puts "❌ telegram_data.json not found. Run the Python script first:"
      puts "   python3 lib/telegram/fetch_channels.py"
      exit 1
    end
    
    puts "📥 Importing Telegram data..."
    
    data = JSON.parse(File.read(json_file))
    
    data.each do |channel_data|
      channel_info = channel_data['channel']
      posts_data = channel_data['posts']
      
      # Find or create channel
      channel = Channel.find_or_initialize_by(telegram_id: channel_info['telegram_id'])
      
      channel.assign_attributes(
        username: channel_info['username'],
        title: channel_info['title'],
        description: channel_info['description'],
        subscriber_count: channel_info['subscriber_count'],
        last_synced_at: Time.current
      )
      
      if channel.save
        puts "✅ Imported channel: #{channel.title} (#{channel.subscriber_count} subscribers)"
        
        # Import posts
        posts_data.each do |post_data|
          post = channel.posts.find_or_initialize_by(
            telegram_message_id: post_data['telegram_message_id']
          )
          
          post.assign_attributes(
            text: post_data['text'],
            views: post_data['views'],
            forwards: post_data['forwards'],
            replies: post_data['replies'],
            posted_at: DateTime.parse(post_data['posted_at'])
          )
          
          post.save
        end
        
        # Recalculate metrics
        channel.calculate_metrics
        
        puts "   📊 Imported #{posts_data.length} posts"
        puts "   📈 Avg views: #{channel.avg_views}, Engagement: #{channel.avg_engagement_rate}%"
      else
        puts "❌ Failed to import #{channel_info['title']}: #{channel.errors.full_messages.join(', ')}"
      end
    end
    
    puts "\n✅ Import complete!"
    puts "📊 Total channels: #{Channel.count}"
    puts "📝 Total posts: #{Post.count}"
  end
  
  desc "Fetch and import channel data from Telegram"
  task fetch_and_import: :environment do
    puts "🚀 Fetching data from Telegram..."
    
    # Run Python script
    system("python3 lib/telegram/fetch_channels.py")
    
    if $?.success?
      puts "\n📥 Now importing data..."
      Rake::Task['telegram:import'].invoke
    else
      puts "❌ Failed to fetch data from Telegram"
      exit 1
    end
  end
end
