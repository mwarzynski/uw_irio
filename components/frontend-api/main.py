from flask import jsonify
from google.cloud import firestore

# GCLOUD_PROJECT
db = firestore.Client()


def main(request):
    news_stream = db.collection(u'news').order_by(u'publishedDate', direction=firestore.Query.DESCENDING).limit(20).stream()
    news = []
    for n in news_stream:
        item = n.to_dict()

        # Improve the 'published date' format.
        item['publishedDate'] = item['publishedDate'].strftime('%Y-%m-%dT%H:%M:%S.%fZ')

        news.append(item)

    return jsonify({"news": news})
