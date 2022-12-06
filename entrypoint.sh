#!/bin/sh

if [ -z "${FIREBASE_TOKEN}" ]; then
    echo "FIREBASE_TOKEN is missing"
    exit 1
fi

if [ -z "${TARGET}" ]; then
    echo "TARGET is missing"
    TARGET = "default"
fi

if [ -z "${WORKING_DIRECTORY}" ]; then
    echo "WORKING_DIRECTORY is missing"
else
    cd ${WORKING_DIRECTORY}
fi

if [ -z "${DEPLOY_ONLY}" ]; then
    echo "DEPLOY_ONLY is missing"
    DEPLOY_ONLY = "functions"
fi

firebase use ${TARGET}

npm run front:build:production

cd backend 
npm run backend:build

if [ -z "${DEPLOY_FUNCTION_AND_HOSTING}" ]; then
    firebase deploy --token ${FIREBASE_TOKEN}
else
    firebase deploy --token ${FIREBASE_TOKEN} --only ${DEPLOY_ONLY}
fi

