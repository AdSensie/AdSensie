#!/usr/bin/env python3
"""
Telegram Channel Data Fetcher for AdSensie
Fetches channel information and posts from Telegram using Telethon
"""

import os
import sys
import json
import asyncio
from datetime import datetime, timedelta
from dotenv import load_dotenv
from telethon import TelegramClient
from telethon.tl.functions.channels import GetFullChannelRequest
from telethon.tl.types import Channel

# Load environment variables
load_dotenv()

API_ID = int(os.getenv('TELEGRAM_API_ID'))
API_HASH = os.getenv('TELEGRAM_API_HASH')
SESSION_NAME = 'adsensie_session'

class TelegramFetcher:
    def __init__(self):
        self.client = TelegramClient(SESSION_NAME, API_ID, API_HASH)
    
    async def connect(self):
        """Connect to Telegram"""
        await self.client.start()
        print("✅ Connected to Telegram")
    
    async def get_channel_info(self, username):
        """
        Fetch channel information
        Args:
            username: Channel username (with or without @)
        Returns:
            dict with channel information
        """
        try:
            # Remove @ if present
            username = username.lstrip('@')
            
            # Get channel entity
            entity = await self.client.get_entity(username)
            
            if not isinstance(entity, Channel):
                print(f"❌ {username} is not a channel")
                return None
            
            # Get full channel info
            full_channel = await self.client(GetFullChannelRequest(entity))
            
            channel_data = {
                'telegram_id': str(entity.id),
                'username': f"@{entity.username}" if entity.username else None,
                'title': entity.title,
                'description': full_channel.full_chat.about or '',
                'subscriber_count': full_channel.full_chat.participants_count or 0,
                'verified': entity.verified,
                'scam': entity.scam,
                'restricted': entity.restricted,
                'created_at': entity.date.isoformat() if hasattr(entity, 'date') else None
            }
            
            print(f"✅ Fetched info for {channel_data['title']}")
            return channel_data
            
        except Exception as e:
            print(f"❌ Error fetching {username}: {str(e)}")
            return None
    
    async def get_channel_posts(self, username, limit=50, days_back=60):
        """
        Fetch recent posts from a channel
        Args:
            username: Channel username
            limit: Maximum number of posts to fetch
            days_back: How many days back to fetch posts
        Returns:
            list of post dictionaries
        """
        try:
            username = username.lstrip('@')
            entity = await self.client.get_entity(username)
            
            # Calculate date limit (make it timezone-aware)
            from datetime import timezone
            date_limit = datetime.now(timezone.utc) - timedelta(days=days_back)
            
            posts = []
            async for message in self.client.iter_messages(entity, limit=limit):
                # Stop if message is too old
                if message.date < date_limit:
                    break
                
                post_data = {
                    'telegram_message_id': message.id,
                    'text': message.text or '',
                    'views': message.views or 0,
                    'forwards': message.forwards or 0,
                    'replies': message.replies.replies if message.replies else 0,
                    'posted_at': message.date.isoformat(),
                    'has_media': message.media is not None,
                    'media_type': type(message.media).__name__ if message.media else None
                }
                posts.append(post_data)
            
            print(f"✅ Fetched {len(posts)} posts from {username}")
            return posts
            
        except Exception as e:
            print(f"❌ Error fetching posts from {username}: {str(e)}")
            return []
    
    async def fetch_channel_data(self, username, posts_limit=50):
        """
        Fetch complete channel data (info + posts)
        Args:
            username: Channel username
            posts_limit: Number of posts to fetch
        Returns:
            dict with channel info and posts
        """
        channel_info = await self.get_channel_info(username)
        if not channel_info:
            return None
        
        posts = await self.get_channel_posts(username, limit=posts_limit)
        
        return {
            'channel': channel_info,
            'posts': posts
        }
    
    async def fetch_multiple_channels(self, usernames, posts_limit=50):
        """
        Fetch data for multiple channels
        Args:
            usernames: List of channel usernames
            posts_limit: Number of posts per channel
        Returns:
            list of channel data dictionaries
        """
        results = []
        for username in usernames:
            print(f"\n📡 Fetching {username}...")
            data = await self.fetch_channel_data(username, posts_limit)
            if data:
                results.append(data)
            # Small delay to avoid rate limiting
            await asyncio.sleep(1)
        
        return results
    
    async def disconnect(self):
        """Disconnect from Telegram"""
        await self.client.disconnect()
        print("\n✅ Disconnected from Telegram")


async def main():
    """Main function to test the fetcher"""
    # Example Ethiopian tech channels
    channels = [
        '@zeit_acc',
        '@Fanuel_Anteneh',
        '@thefrectonz',
    ]
    
    fetcher = TelegramFetcher()
    
    try:
        await fetcher.connect()
        
        # Fetch data from channels
        results = await fetcher.fetch_multiple_channels(channels, posts_limit=30)
        
        # Save to JSON file
        output_file = 'telegram_data.json'
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(results, f, indent=2, ensure_ascii=False)
        
        print(f"\n✅ Data saved to {output_file}")
        print(f"📊 Fetched data from {len(results)} channels")
        
    except Exception as e:
        print(f"\n❌ Error: {str(e)}")
    finally:
        await fetcher.disconnect()


if __name__ == '__main__':
    # Run the async main function
    asyncio.run(main())
