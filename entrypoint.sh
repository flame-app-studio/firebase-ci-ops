#!/bin/sh

if [ -z "${TARGET}" ]; then
    echo "TARGET is missing"

    TARGET = "default"
fi

if [ -z "${FUNCTIONS_DIRECTORY}" ]; then
    echo "FUNCTIONS_DIRECTORY is missing set functions as default"

    FUNCTIONS_DIRECTORY = "functions"
fi

if [ -z "${BUILD_COMMAND}" ]; then
    echo "BUILD_COMMAND is missing set build as default"

    BUILD_COMMAND = "build"
fi

cd ${FUNCTIONS_DIRECTORY}

npm i

npm run ${BUILD_COMMAND}

firebase use ${TARGET}

firebase deploy --only functions
