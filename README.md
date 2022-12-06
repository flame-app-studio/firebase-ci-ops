# Deploy to Firebase Functions With Project Targets!

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

Then, specify a value (as indicated below in the example workflow) or none for default.

### Example workflow

```
name: Firebase
on:
  push:
    branches:
    - master
jobs:
  main:
    name: Deploy
    runs-on: ubuntu-latest
    steps:
    - name: Check out code
      uses: actions/checkout@master
    - name: Deploy to Firebase
      uses: flameappstudio/firebase-ci-ops@1.0.0
      env:
        FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}
        TARGET: default or production or staging or your custom env name
        WORKING_DIRECTORY: functions
```
