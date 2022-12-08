# Deploy Firebase function with environnement target

Deploy Firebase functions with environments for better continuous integration. Need to deploy to production on one branch, then to development on another? Specify a 'target' by using the <key, value> set in your `firebaserc` file. For example:

```
{
  "projects": {
    "default": "default project id",
    "production": "production project id",
    "staging": "staging project id"
  }
}
```

This action use [https://github.com/marketplace/actions/authenticate-to-google-cloud](https://github.com/marketplace/actions/authenticate-to-google-cloud) for Google services authentication

## Arguments

---

Function Directory in your project

```
FUNCTIONS_DIRECTORY: 'functions' or your custom function directory
```

Npm build command

```
BUILD_COMMAND: 'build' or your custom build command
```

Firebase env name, see [https://firebase.google.com/docs/projects/dev-workflows/overview-environments](https://firebase.google.com/docs/projects/dev-workflows/overview-environments)

```
TARGET: 'default' or your env name
```

## Instructions

1. Get your Firebase service account json from firebase admin for each of your project env

2. Create a FIREBASE_SERVICE_ACCOUNT_STAGING and FIREBASE_SERVICE_ACCOUNT_PRODUCTION in your Github repo secret, add your firebase credentials. If you don't have multiples firebase env create FIREBASE_SERVICE_ACCOUNT secret only and past corresponding Firebase service account json.

3. (Info) If you want to deploy only your other firebase service (firestore rules, storage rules), you have to do this manually. See [https://firebase.google.com/docs/cli](https://firebase.google.com/docs/cli)

### Example production workflow

---

```
name: Deploy production

on:
  workflow_run:
    workflows: [Semantic Release]
    types:
      - completed

jobs:
  deploy_hosting:
    runs-on: ubuntu-latest
    environment: [your github secret environnement]
    steps:
      - uses: actions/checkout@v3
      - run: npm ci && npm run [your front build command]
      - uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          channelId: live
          repoToken: "${{ secrets.GITHUB_TOKEN }}"
          firebaseServiceAccount: "${{ secrets.FIREBASE_SERVICE_ACCOUNT_PRODUCTION }}"
          projectId: [your project id]

  deploy_functions:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - id: "auth"
        name: "Authenticate to Google Cloud"
        uses: "google-github-actions/auth@v1"
        with:
          credentials_json: "${{ secrets.FIREBASE_SERVICE_ACCOUNT_PRODUCTION }}"
      - name: Firebase CI Ops
        uses: flame-app-studio/firebase-ci-ops@v1.4.0
        env:
          TARGET: [your firebase target]
```

### Example staging workflow

---

```
name: Deploy staging

"on":
  push:
    branches:
      - develop

jobs:
  deploy_hosting:
    runs-on: ubuntu-latest
    environment: [your github secret environnement]
    steps:
      - uses: actions/checkout@v3
      - run: npm ci && npm run [your front build command]
      - uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          channelId: live
          repoToken: "${{ secrets.GITHUB_TOKEN }}"
          firebaseServiceAccount: "${{ secrets.FIREBASE_SERVICE_ACCOUNT_STAGING }}"
          projectId: [your project id]

  deploy_functions:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - id: "auth"
        name: "Authenticate to Google Cloud"
        uses: "google-github-actions/auth@v1"
        with:
          credentials_json: "${{ secrets.FIREBASE_SERVICE_ACCOUNT_STAGING }}"
      - name: Firebase CI Ops
        uses: flame-app-studio/firebase-ci-ops@v1.4.0
        env:
          TARGET: [your firebase target]

```

<br/><br/>

**_Crafted with ❤️ by Jean-Baptiste Thery | Flame App Studio | [www.flameapp.studio](www.flameapp.studio)_**
