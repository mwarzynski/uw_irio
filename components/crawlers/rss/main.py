import json
import os
import feedparser
import datetime
import logging

from google.cloud import pubsub_v1


# Instantiates a Pub/Sub client
publisher = pubsub_v1.PublisherClient()
PROJECT_ID = os.getenv('PROJECT_ID')

topic_name = "news"


# Publishes a message to a Cloud Pub/Sub topic.
def main(event, context):
    feed = feedparser.parse("https://hnrss.org/frontpage")
    for entry in feed.entries:
        try:
            date_published = datetime.datetime.strptime(entry['published'], '%a, %d %b %Y %H:%M:%S +0000')
        except Exception as e:
            logging.warn(f"[date] parsing date error={e}; entry={entry}")
            continue

        try:
            message = {'title': entry['title'], 'url': entry['link'], 'publishedDate': date_published.strftime('%Y-%m-%dT%H:%M:%S.%fZ')}
        except Exception as e:
            logging.warn(f"[message] preparing news error={e}; entry={entry}")
            continue

        try:
            message_json = json.dumps(message)
            message_bytes = message_json.encode('utf-8')
        except Exception as e:
            logging.warn(f"[json] dumping news error={e}; entry={message}")
            continue

        try:
            topic_path = publisher.topic_path(PROJECT_ID, topic_name)
            publish_future = publisher.publish(topic_path, data=message_bytes)
            publish_future.result()
        except Exception as e:
            logging.warn(f"[pubsub] publishing news error={e}; entry={message}")
            continue

    return "OK"
