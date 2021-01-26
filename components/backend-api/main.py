import json
import base64
import hashlib
import datetime


from google.cloud import firestore
from google.cloud import logging

log = google.cloud.logging.Client().logger("backend-api").log_text

# GCLOUD_PROJECT
db = firestore.Client()


def main(event, context):
    if 'data' not in event:
        log(f"[event] no 'data' in object: {event}", severity="WARN")
        return "OK"

    news_raw = event['data']

    try:
        news = json.loads(base64.b64decode(news_raw))
    except Exception as e:
        log(f"[json.loads] error={e}; news={news_raw}", severity="ERROR")
        return "ERROR"

    try:
        news_id = hashlib.md5(news_raw.encode('utf-8')).hexdigest()
    except Exception as e:
        log(f"[hashlib.md5] error={e}; news={news_raw}", severity="ERROR")
        return "ERROR"

    try:
        news["publishedDate"] = datetime.datetime.strptime(news["publishedDate"], '%Y-%m-%dT%H:%M:%S.%fZ') # '2012-05-29T19:30:03.283Z'
    except Exception as e:
        log(f"[date] parse published date error={e}; news={news_raw}", severity="ERROR")
        return "ERROR"

    try:
        # Add a new doc in collection 'news' with ID as a news hash.
        doc = db.collection(u'news').document(news_id)
        if doc.get().exists:
            log(f"id={news_id} already exists")
            return "OK"
        doc.set(news)
        log(f"id={news_id} set in database")
    except Exception as e:
        log(f"[firestore.set] error={e}; id={news_id}; news={news_raw}", severity="ERROR")
        return "ERROR"

    log(f"news (id={news_id}) set in database")
    return "OK"
