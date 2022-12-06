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

## Instructions

---

1. Login to firebase ci in your terminal

```
firebase login:ci
```

2. Get your FIREBASE_TOKEN from your terminal

example copy the prompt like :

```
1//XXXXXXXXXXXXXXXXXXXXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-XXXX
```

3. Create a FIREBASE_TOKEN entry in your Github repos secrets with your token as value

4. Follow the [Github](https://docs.github.com/actions) doc to add the workflow to your repos actions

## Arguments

---

Prompted token from command **_firebase login:ci_**

```
FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}
```

Firebase env name, see [https://firebase.google.com/docs/projects/dev-workflows/overview-environments](https://firebase.google.com/docs/projects/dev-workflows/overview-environments)

```
TARGET: 'default' or your env name
```

Add this if you want to deploy storage rules

```
DEPLOY_STORAGE: true
```

Add this if you want to deploy firestore rules

```
DEPLOY_FIRESTORE_RULES: true
```

Add this if you want to deploy firestore index rules

```
DEPLOY_FIRESTORE_INDEX: true
```

Add this if you want to deploy database rules

```
DEPLOY_FIRESTORE_INDEX: true
```

## Example production workflow

---

```
name: Deploy production

"on":
  release:
    types: [published]

jobs:
  deploy_hosting:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm ci && npm run build
      - uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: "${{ secrets.GITHUB_TOKEN }}"
          firebaseServiceAccount: "${{ secrets.FIREBASE_SERVICE_ACCOUNT_PRODUCTION }}"
          channelId: live
          projectId: your-project-id

  deploy_functions:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Firebase CI Ops
        uses: flame-app-studio/firebase-ci-ops@v1.1.0
        env:
          FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}
          TARGET: production
          WORKING_DIRECTORY: functions
          DEPLOY_STORAGE: true
          DEPLOY_FIRESTORE_RULES: true
          DEPLOY_FIRESTORE_INDEX: true
```

## Example staging workflow

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
    steps:
      - uses: actions/checkout@v3
      - run: npm ci && npm run build
      - uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: "${{ secrets.GITHUB_TOKEN }}"
          firebaseServiceAccount: "${{ secrets.FIREBASE_SERVICE_ACCOUNT_STAGING }}"
          channelId: live
          projectId: your-project-id

  deploy_functions:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Firebase CI Ops
        uses: flame-app-studio/firebase-ci-ops@v1.1.0
        env:
          FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}
          TARGET: staging
          WORKING_DIRECTORY: functions
          DEPLOY_STORAGE: true
          DEPLOY_FIRESTORE_RULES: true
          DEPLOY_FIRESTORE_INDEX: true
```

<br/><br/>

**_Crafted with ❤️ by Jean-Baptiste Thery | Flame App Studio | [www.flameapp.studio](www.flameapp.studio)_**
