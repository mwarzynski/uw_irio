from flask import jsonify
from google.cloud import firestore

# GCLOUD_PROJECT
db = firestore.Client()


def main(request):
    news_ref = db.collection(u'news')
    news = news_ref.stream()
    return jsonify({"news": [n.to_dict() for n in news]})
