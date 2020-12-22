from flask import jsonify
from google.cloud import firestore

# GCLOUD_PROJECT
db = firestore.Client()


def main(request):
    news_ref = db.collection(u'news')
    news = []
    for n in news_ref.stream():
        item = n.to_dict()

        # Improve the 'published date' format.
        item['publishedDate'] = item['publishedDate'].strftime('%Y-%m-%dT%H:%M:%S.%fZ')

        news.append(item)

    return jsonify({"news": news})
