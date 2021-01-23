# IRIO - News Feed

## How to deploy?

Build frontend:
```bash
cd components/frontend
npm install
npm run-script build
```

Deploy the application
```bash

# TODO: We could probably move enabling APIs to terraform too.
gcloud services enable cloudscheduler.googleapis.com
gcloud services enable cloudfunctions.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable redis.googleapis.com

cd infrastructure
export TF_VAR_project=$(gcloud config get-value project)
terraform init
terraform apply
```

There will be a question if you *really* want to apply all of these changes. Type "yes" and press enter. After a while,
you should see a success message with:
```
Outputs:

lb_ip = "35.190.95.151"
url = "https://us-central1-irio-project.cloudfunctions.net/frontend-api"
```

Feel free to check it out (should still work).

If you will run `terraform apply` more than one time, then you could see errors like:

```
Error: Error creating App Engine application: googleapi: Error 409: This application already exists and cannot be re-created., alreadyExists
```

Don't worry, we can only create the GAE once (we can't delete it), therefore terraform complains for the consecutive applies.

In order to fix this, we need to import the GAE to our local terraform state:
```
terraform import google_app_engine_application.app project-id
```

## Load Tests

https://github.com/mwarzynski/uw_irio/issues/4
