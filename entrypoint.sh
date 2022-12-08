#!/bin/sh

if [ -z "${TARGET}" ]; then
    echo "TARGET is missing"

    TARGET = "default"
fi

firebase use ${TARGET}

firebase deploy --only functions
