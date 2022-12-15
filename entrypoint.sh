#!/bin/sh
if [ -z "${FIREBASE_CI_TOKEN}" ]; then
    echo "FIREBASE_CI_TOKEN is missing"

    exit 1
fi


if [ -z "${TARGET}" ]; then
    echo "TARGET is missing"

    TARGET = "default"
fi

if [ -z "${FUNCTION_DIRECTORY}" ]; then
    echo "FUNCTION_DIRECTORY is missing, set function directory to functions"

    FUNCTION_DIRECTORY = "functions"
fi

cd ${FUNCTION_DIRECTORY} 

if [ -z "${NPM_ACCESS_TOKEN}" ]; then
    echo "NPM_ACCESS_TOKEN is missing, skip .npmrc creation"
else 
    echo "//registry.npmjs.org/:_authToken=${NPM_ACCESS_TOKEN}" >> .npmrc
fi

npm ci

firebase use ${TARGET} --token ${FIREBASE_CI_TOKEN}

firebase deploy --token ${FIREBASE_CI_TOKEN} --only functions

if [ -z "${DEPLOY_STORAGE}" ]; then
    echo "DEPLOY_STORAGE is missing, skip database storage rules deploy"  
else 
    firebase deploy --token ${FIREBASE_CI_TOKEN} --only storage
fi

if [ -z "${DEPLOY_FIRESTORE_RULES}" ]; then
    echo "DEPLOY_FIRESTORE_RULES is missing, skip fire store rules deploy"
else 
    firebase deploy --token ${FIREBASE_CI_TOKEN} --only firestore
fi