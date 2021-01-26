import os
from cachetools import cached, TTLCache
from flask import jsonify
from google.cloud import firestore
import google.cloud.logging

log = google.cloud.logging.Client().logger("frontend-api").log_text

# GCLOUD_PROJECT
db = firestore.Client()

CACHE_TTL = int(os.getenv("CACHE_TTL", 60))

@cached(cache=TTLCache(maxsize=1, ttl=CACHE_TTL))
def get_news():
    news_stream = db.collection(u'news').order_by(u'publishedDate', direction=firestore.Query.DESCENDING).limit(20).stream()
    news = []
    for n in news_stream:
        item = n.to_dict()
        item['publishedDate'] = item['publishedDate'].strftime('%Y-%m-%dT%H:%M:%S.%fZ')
        news.append(item)
    return news

def main(request):
    news = get_news()
    log("news were fetched", severity="DEBUG")
    return (jsonify({"news": news}), 200, {"Access-Control-Allow-Origin": "*"})
