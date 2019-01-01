#!/bin/bash

LATEST_HUGO_VERSION=0.53

source ${WERCKER_STEP_ROOT}/helpers/functions.sh
source ${WERCKER_STEP_ROOT}/helpers/dependencies.sh
source ${WERCKER_STEP_ROOT}/helpers/parameters.sh

# install pygments if requested
if [ "$WERCKER_HUGO_BUILD_INSTALL_PYGMENTS" == "true" ]; then
    install_pygments
fi

# Check if hugo is already installed in the container
if (command_exists "hugo") && "$WERCKER_HUGO_BUILD_FORCE_INSTALL" == "false"; then
  HUGO_COMMAND="hugo"
else
  # Check if this version of Hugo is already installed in the step
  # If it exists, keep the current HUGO_COMMAND, otherwise install Hugo
  HUGO_COMMAND=${WERCKER_STEP_ROOT}/bin/hugo_$WERCKER_HUGO_BUILD_VERSION
  # Curl needs to be installed to handle (https) calls by Hugo
  install_curl
  if [ ! -f $HUGO_COMMAND ]; then
    install_hugo
  fi
fi

# Clean the public/output directory before running Hugo
if [ "$WERCKER_HUGO_BUILD_CLEAN_BEFORE" == "true" ]; then
  echo "Cleaning the public directory"
  rm -rf ${WERCKER_SOURCE_DIR}/${WERCKER_HUGO_BUILD_BASEDIR}/public/*
fi

# Ensure a content directory is present as per Issue #42
mkdir -p ${WERCKER_SOURCE_DIR}/${WERCKER_HUGO_BUILD_BASEDIR}/content

echo "Running the Hugo command"
echo "${HUGO_COMMAND} --source=${WERCKER_SOURCE_DIR}/${WERCKER_HUGO_BUILD_BASEDIR} ${WERCKER_HUGO_BUILD_FLAGS}"

eval ${HUGO_COMMAND} --source="${WERCKER_SOURCE_DIR}/${WERCKER_HUGO_BUILD_BASEDIR}" ${WERCKER_HUGO_BUILD_FLAGS}
