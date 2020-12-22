## How to run Google Cloud Function locally?

For the ones with HTTP trigger:

```
pip install functions-framework
cd frontend-api
functions-framework --target main
```

and that's it. You can call this function locally using:

```
curl "http://localhost:8080"
```

## Frontend

```
npx create-react-app frontend --template material-ui
```
