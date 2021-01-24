import os
import logging
from cachetools import cached, TTLCache
from flask import jsonify
from google.cloud import firestore
from jsonformatter import basicConfig

# Configure built-in Python logger to use Cloud Logging format
basicConfig(
    format='{\"severity\": \"%(levelname)s\", \"message\": \"%(message)s\"}',
    level=logging.INFO)

# GCLOUD_PROJECT
db = firestore.Client()

CACHE_TTL = int(os.getenv("CACHE_TTL", 60))

@cached(cache=TTLCache(maxsize=1, ttl=CACHE_TTL))
def get_news():
    news_stream = db.collection(u'news').order_by(u'publishedDate', direction=firestore.Query.DESCENDING).limit(20).stream()
    news = []
    for n in news_stream:
        item = n.to_dict()
        # Improve the 'published date' format.
        item['publishedDate'] = item['publishedDate'].strftime('%Y-%m-%dT%H:%M:%S.%fZ')
        news.append(item)
    return news

def main(request):
    headers = {
        'Access-Control-Allow-Origin': '*'
    }

    return (jsonify({"news": get_news()}), 200, headers)
