#!/bin/sh
if [ -z "${FIREBASE_CI_TOKEN}" ]; then
    echo "FIREBASE_CI_TOKEN is missing"
fi


if [ -z "${TARGET}" ]; then
    echo "TARGET is missing"

    TARGET = "default"
fi

firebase use ${TARGET} --token ${FIREBASE_CI_TOKEN}

firebase deploy --token ${FIREBASE_CI_TOKEN} --only functions

if [ -z "${DEPLOY_STORAGE}" ]; then
    echo "DEPLOY_STORAGE is missing, skip database storage rules deploy"

        DEPLOY_STORAGE = "null"
else 
    firebase deploy --token ${FIREBASE_CI_TOKEN} --only storage
fi

if [ -z "${DEPLOY_FIRESTORE_RULES}" ]; then
    echo "DEPLOY_FIRESTORE_RULES is missing, skip fire store rules deploy"

    DEPLOY_FIRESTORE_RULES = "null"
else 
    firebase deploy --token ${FIREBASE_CI_TOKEN} --only firestore
fi