# Deploy Firebase function with environnement target

Deploy Firebase functions and optionally other service (Firestore rules, Storage, Database) with environments for better continuous integration. Need to deploy to production on one branch, then to development on another? Specify a 'target' by using the <key, value> set in your `firebaserc` file. For example:

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

Your Firebase ci token, to get this see [https://firebase.google.com/docs/cli](https://firebase.google.com/docs/cli)

```
FIREBASE_CI_TOKEN
```

Firebase env name, see [https://firebase.google.com/docs/projects/dev-workflows/overview-environments](https://firebase.google.com/docs/projects/dev-workflows/overview-environments)

```
TARGET: 'default' or your env name
```

If true deploy Firebase firestore rules

```
DEPLOY_FIRESTORE_RULES: true or false
```

If true write .npmrc file with npm token

```
NPM_ACCESS_TOKEN: string
```

Custom function directory

```
FUNCTION_DIRECTORY: string
```

### Example workflow

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
      - name: Firebase CI Ops
        uses: flame-app-studio/firebase-ci-ops@[current version]
        env:
          FIREBASE_CI_TOKEN: [your firebase ci token]  ***! required***
          TARGET: [your firebase target]
          DEPLOY_DATABASE: [true or false]
          DEPLOY_STORAGE: [true or false]
          DEPLOY_FIRESTORE_RULES: [true or false]
```

<br/><br/>

**_Crafted with ❤️ by Jean-Baptiste Thery | Flame App Studio | [www.flameapp.studio](www.flameapp.studio)_**
