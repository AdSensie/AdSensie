# Helper method to generate realistic post content
def generate_post_content(channel_title)
  topics = {
    "News" => [
      "Breaking: New tech innovation announced in Ethiopia",
      "Latest updates from the Ethiopian tech ecosystem",
      "Tech industry trends you need to know about",
      "Major development in Ethiopian technology sector"
    ],
    "Job" => [
      "🔥 Hiring: Senior Developer needed - Remote OK",
      "New job opportunity: Full-stack developer position",
      "💼 Career opportunity: Join our growing tech team",
      "Urgent: Multiple tech positions available"
    ],
    "Developer" => [
      "💻 New tutorial: Building scalable applications",
      "Code snippet of the day: Optimize your workflow",
      "Best practices for clean code architecture",
      "Project showcase: Check out this amazing app"
    ],
    "Startup" => [
      "🚀 Startup funding opportunity announced",
      "Success story: Ethiopian startup raises $1M",
      "Pitch competition coming up - Register now!",
      "Entrepreneurship tips for tech founders"
    ],
    "Learning" => [
      "📚 Free course alert: Limited time offer",
      "New learning resource added to our library",
      "Study group forming - Join us!",
      "Tutorial series: Master this technology"
    ]
  }
  
  # Find matching topic
  topic_key = topics.keys.find { |key| channel_title.include?(key) } || "Developer"
  topics[topic_key].sample + " - " + Faker::Lorem.sentence(word_count: 8)
end

# Clear existing data
puts "Clearing existing data..."
CollectionChannel.destroy_all
Collection.destroy_all
Post.destroy_all
Channel.destroy_all
User.destroy_all

puts "Creating users..."
# Create demo users
user1 = User.create!(
  email: "demo@adsensie.com",
  password: "password",
  password_confirmation: "password"
)

user2 = User.create!(
  email: "advertiser@adsensie.com",
  password: "password",
  password_confirmation: "password"
)

puts "Creating Ethiopian tech channels..."

# Ethiopian Tech Channels - realistic data
channels_data = [
  {
    telegram_id: "ethiotech_news",
    username: "@EthioTechNews",
    title: "Ethiopian Tech News",
    description: "Latest technology news, updates, and innovations from Ethiopia and around the world. Daily tech updates in English and Amharic.",
    subscriber_count: 45_000,
    growth_rate: 15.5
  },
  {
    telegram_id: "dev_ethiopia",
    username: "@DevEthiopia",
    title: "Developers Ethiopia",
    description: "Community for Ethiopian software developers. Share code, projects, and learn together. Programming tutorials and resources.",
    subscriber_count: 32_000,
    growth_rate: 22.3
  },
  {
    telegram_id: "ethio_jobs_tech",
    username: "@EthioJobsTech",
    title: "Ethiopian Tech Jobs",
    description: "Tech job opportunities in Ethiopia and remote positions. Daily job postings for developers, designers, and IT professionals.",
    subscriber_count: 58_000,
    growth_rate: 18.7
  },
  {
    telegram_id: "startup_ethiopia",
    username: "@StartupEthiopia",
    title: "Startup Ethiopia",
    description: "Ethiopian startup ecosystem news, funding opportunities, and entrepreneurship resources. Connect with founders and investors.",
    subscriber_count: 28_500,
    growth_rate: 12.4
  },
  {
    telegram_id: "python_ethiopia",
    username: "@PythonEthiopia",
    title: "Python Ethiopia",
    description: "Python programming community in Ethiopia. Tutorials, code snippets, and project collaborations. Learn Python together.",
    subscriber_count: 19_800,
    growth_rate: 25.1
  },
  {
    telegram_id: "web_dev_et",
    username: "@WebDevET",
    title: "Web Development Ethiopia",
    description: "Web development tutorials, frameworks, and best practices. React, Vue, Angular, and backend technologies.",
    subscriber_count: 24_300,
    growth_rate: 19.8
  },
  {
    telegram_id: "ai_ml_ethiopia",
    username: "@AIMLEthiopia",
    title: "AI & ML Ethiopia",
    description: "Artificial Intelligence and Machine Learning community. Research papers, tutorials, and AI projects in Ethiopia.",
    subscriber_count: 15_600,
    growth_rate: 31.2
  },
  {
    telegram_id: "mobile_dev_et",
    username: "@MobileDevET",
    title: "Mobile Development Ethiopia",
    description: "Android and iOS development community. Flutter, React Native, and native app development tutorials.",
    subscriber_count: 21_400,
    growth_rate: 16.9
  },
  {
    telegram_id: "freelance_ethiopia",
    username: "@FreelanceEthiopia",
    title: "Freelance Ethiopia",
    description: "Freelancing opportunities, tips, and success stories. Upwork, Fiverr, and remote work guidance for Ethiopians.",
    subscriber_count: 41_200,
    growth_rate: 14.3
  },
  {
    telegram_id: "cybersec_et",
    username: "@CyberSecET",
    title: "Cybersecurity Ethiopia",
    description: "Cybersecurity news, ethical hacking tutorials, and security best practices. Protect yourself and your systems.",
    subscriber_count: 12_800,
    growth_rate: 20.5
  },
  {
    telegram_id: "data_science_et",
    username: "@DataScienceET",
    title: "Data Science Ethiopia",
    description: "Data science, analytics, and visualization. Python, R, SQL tutorials and real-world data projects.",
    subscriber_count: 17_900,
    growth_rate: 23.7
  },
  {
    telegram_id: "blockchain_et",
    username: "@BlockchainET",
    title: "Blockchain Ethiopia",
    description: "Blockchain technology, cryptocurrency, and Web3 development. Smart contracts and DeFi in Ethiopia.",
    subscriber_count: 22_600,
    growth_rate: 28.4
  },
  {
    telegram_id: "ui_ux_ethiopia",
    username: "@UIUXEthiopia",
    title: "UI/UX Ethiopia",
    description: "Design community for Ethiopian designers. UI/UX principles, Figma tutorials, and design inspiration.",
    subscriber_count: 14_200,
    growth_rate: 17.6
  },
  {
    telegram_id: "devops_ethiopia",
    username: "@DevOpsEthiopia",
    title: "DevOps Ethiopia",
    description: "DevOps practices, CI/CD, Docker, Kubernetes, and cloud infrastructure. AWS, Azure, and GCP tutorials.",
    subscriber_count: 11_500,
    growth_rate: 21.8
  },
  {
    telegram_id: "tech_events_et",
    username: "@TechEventsET",
    title: "Tech Events Ethiopia",
    description: "Upcoming tech events, hackathons, meetups, and conferences in Ethiopia. Network with the tech community.",
    subscriber_count: 26_700,
    growth_rate: 13.2
  },
  {
    telegram_id: "learning_resources_et",
    username: "@LearningResourcesET",
    title: "Learning Resources Ethiopia",
    description: "Free courses, tutorials, books, and learning materials for Ethiopian tech enthusiasts. Udemy, Coursera deals.",
    subscriber_count: 38_900,
    growth_rate: 16.1
  },
  {
    telegram_id: "javascript_et",
    username: "@JavaScriptET",
    title: "JavaScript Ethiopia",
    description: "JavaScript community in Ethiopia. Node.js, React, Vue, and modern JS frameworks. Code challenges and projects.",
    subscriber_count: 20_100,
    growth_rate: 19.3
  },
  {
    telegram_id: "tech_hardware_et",
    username: "@TechHardwareET",
    title: "Tech Hardware Ethiopia",
    description: "Computer hardware, gadgets, and electronics. PC builds, reviews, and where to buy tech in Ethiopia.",
    subscriber_count: 16_400,
    growth_rate: 11.7
  },
  {
    telegram_id: "remote_work_et",
    username: "@RemoteWorkET",
    title: "Remote Work Ethiopia",
    description: "Remote work opportunities for Ethiopians. Work from home tips, international job boards, and success stories.",
    subscriber_count: 52_300,
    growth_rate: 24.9
  },
  {
    telegram_id: "tech_business_et",
    username: "@TechBusinessET",
    title: "Tech Business Ethiopia",
    description: "Technology business news, market analysis, and investment opportunities in Ethiopian tech sector.",
    subscriber_count: 19_200,
    growth_rate: 15.8
  }
]

channels = channels_data.map do |data|
  Channel.create!(data)
end

puts "Created #{channels.count} channels"

puts "Generating posts for each channel..."

channels.each do |channel|
  # Generate 15-40 posts per channel
  num_posts = rand(15..40)
  
  num_posts.times do |i|
    # Posts from the last 60 days
    posted_date = rand(60).days.ago + rand(24).hours
    
    # Realistic view counts based on subscriber count
    base_views = (channel.subscriber_count * rand(0.05..0.25)).to_i
    views = base_views + rand(-base_views/4..base_views/4)
    
    Post.create!(
      channel: channel,
      telegram_message_id: Faker::Number.unique.number(digits: 10),
      text: generate_post_content(channel.title),
      views: views,
      forwards: (views * rand(0.01..0.05)).to_i,
      replies: (views * rand(0.005..0.02)).to_i,
      posted_at: posted_date
    )
  end
  
  # Calculate metrics for the channel
  channel.calculate_metrics
  
  puts "  ✓ #{channel.title}: #{channel.posts.count} posts"
end

puts "Creating sample collections..."

# Create sample collections for demo user
collection1 = user1.collections.create!(
  name: "Q1 2025 Ad Campaign",
  description: "High engagement channels for Q1 advertising campaign targeting developers"
)

collection2 = user1.collections.create!(
  name: "Job Posting Channels",
  description: "Channels focused on tech jobs and career opportunities"
)

collection3 = user1.collections.create!(
  name: "Budget-Friendly Options",
  description: "Smaller channels with good engagement rates"
)

# Add channels to collections
high_engagement_channels = channels.sort_by(&:avg_engagement_rate).reverse.take(5)
high_engagement_channels.each_with_index do |channel, index|
  collection1.collection_channels.create!(
    channel: channel,
    notes: "Strong engagement rate of #{channel.avg_engagement_rate}%",
    position: index + 1
  )
end

job_channels = channels.select { |c| c.title.include?("Job") || c.title.include?("Remote") || c.title.include?("Freelance") }
job_channels.each_with_index do |channel, index|
  collection2.collection_channels.create!(
    channel: channel,
    notes: "Relevant for job postings",
    position: index + 1
  )
end

smaller_channels = channels.select { |c| c.subscriber_count < 25_000 && c.avg_engagement_rate > 5 }
smaller_channels.take(6).each_with_index do |channel, index|
  collection3.collection_channels.create!(
    channel: channel,
    notes: "Good value for budget campaigns",
    position: index + 1
  )
end

puts "Created #{Collection.count} collections"

puts "\n✅ Seed data created successfully!"
puts "\nSummary:"
puts "  - #{User.count} users"
puts "  - #{Channel.count} channels"
puts "  - #{Post.count} posts"
puts "  - #{Collection.count} collections"
puts "\nDemo login credentials:"
puts "  Email: demo@adsensie.com"
puts "  Password: password"
