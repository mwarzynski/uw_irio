# How to 'deploy'?

```
PUBLIC_URL=https://storage.googleapis.com/bucket-name/ npm run build
gsutil mb gs://bucket-name
gsutil defacl set public-read gs://bucket-name
cd build && gsutil -m rsync -r ./ gs://bucket-name
```
