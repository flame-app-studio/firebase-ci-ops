#!/bin/sh

if [ -z "${FIREBASE_TOKEN}" ]; then
    echo "FIREBASE_TOKEN is missing"
    exit 1
fi

if [ -z "${TARGET}" ]; then
    echo "TARGET is missing"

    TARGET = "default"
fi

firebase use ${TARGET}

firebase deploy --token ${FIREBASE_TOKEN} --only functions

if [ -z "${DEPLOY_DATABASE}" ]; then
    echo "DEPLOY_DATABASE is missing, skip database rules deploy"
else 
    firebase deploy --token ${FIREBASE_TOKEN} --only database
fi

if [ -z "${DEPLOY_STORAGE}" ]; then
    echo "DEPLOY_STORAGE is missing, skip database storage rules deploy"
else 
    firebase deploy --token ${FIREBASE_TOKEN} --only storage
fi

if [ -z "${DEPLOY_FIRESTORE_RULES}" ]; then
    echo "DEPLOY_FIRESTORE_RULES is missing, skip database rules deploy"
else 
    firebase deploy --token ${FIREBASE_TOKEN} --only firestore:rules
fi

if [ -z "${DEPLOY_FIRESTORE_INDEX}" ]; then
    echo "DEPLOY_FIRESTORE_INDEX is missing, skip database indexes deploy"
else 
    firebase deploy --token ${FIREBASE_TOKEN} --only firestore:indexes
fi
