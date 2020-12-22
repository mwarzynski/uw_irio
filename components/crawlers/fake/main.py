import json
import os

from google.cloud import pubsub_v1


# Instantiates a Pub/Sub client
publisher = pubsub_v1.PublisherClient()
PROJECT_ID = os.getenv('PROJECT_ID')

topic_name = "news"


def main(request):
    for i in range(0, 2):
        message_json = json.dumps({
            'title': f"IRIO project is not that boring... {i}",
            'url': 'https://google.com',
            'publishedDate': '2020-12-20T19:30:03.283Z'
        })
        message_bytes = message_json.encode('utf-8')

        try:
            topic_path = publisher.topic_path(PROJECT_ID, topic_name)
            publish_future = publisher.publish(topic_path, data=message_bytes)
            publish_future.result()
        except Exception as e:
            print(e)
            return e

    return "OK"