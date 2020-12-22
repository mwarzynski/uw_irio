import json
import os

from google.cloud import pubsub_v1


# Instantiates a Pub/Sub client
publisher = pubsub_v1.PublisherClient()
PROJECT_ID = os.getenv('PROJECT_ID')

topic_name = "news"


# Publishes a message to a Cloud Pub/Sub topic.
def main(event, context):
    message_json = json.dumps({
        'title': "IRIO project is not that boring...",
        'url': 'https://google.com',
        'publishedDate': '2020-12-20T19:30:03.283Z'
    })
    message_bytes = message_json.encode('utf-8')

    topic_path = publisher.topic_path(PROJECT_ID, topic_name)
    publish_future = publisher.publish(topic_path, data=message_bytes)
    publish_future.result()

    return None
