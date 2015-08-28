#/bin/bash

LATEST_HUGO_VERSION=0.14

command_exists()
{
    hash "$1" 2>/dev/null
}

install_hugo()
{
    # check if curl is installed
    # install otherwise
    if ! command_exists curl; then
        if command_exists apt-get; then
            apt-get update
            apt-get install -y curl
        else
            yum install -y curl
        fi
    fi
    
    cd $WERCKER_STEP_ROOT    
    curl -sL https://github.com/spf13/hugo/releases/download/v${WERCKER_HUGO_BUILD_VERSION}/hugo_${WERCKER_HUGO_BUILD_VERSION}_linux_amd64.tar.gz -o ${WERCKER_STEP_ROOT}/hugo_${WERCKER_HUGO_BUILD_VERSION}_linux_amd64.tar.gz
    tar xzf hugo_${WERCKER_HUGO_BUILD_VERSION}_linux_amd64.tar.gz
    HUGO_COMMAND=${WERCKER_STEP_ROOT}/hugo_${WERCKER_HUGO_BUILD_VERSION}_linux_amd64/hugo_${WERCKER_HUGO_BUILD_VERSION}_linux_amd64
}

if [ "$WERCKER_HUGO_BUILD_VERSION" == "false" ]; then
    echo "The Hugo version in your wercker.yml isn't set correctly. Please put quotes around it. We will continue using the latest version ($LATEST_HUGO_VERSION)."
    WERCKER_HUGO_BUILD_VERSION=""
fi

if [ ! -n "$WERCKER_HUGO_BUILD_VERSION" ]; then
    WERCKER_HUGO_BUILD_VERSION=$LATEST_HUGO_VERSION
fi

if [ ! -n "$WERCKER_HUGO_BUILD_FLAGS" ]; then
    WERCKER_HUGO_BUILD_FLAGS=""
fi

if [ -n "$WERCKER_HUGO_BUILD_THEME" ]; then
    WERCKER_HUGO_BUILD_FLAGS=$WERCKER_HUGO_BUILD_FLAGS" --theme="${WERCKER_HUGO_BUILD_THEME}
fi

if [ -n "$WERCKER_HUGO_BUILD_CONFIG" ]; then
    WERCKER_HUGO_BUILD_FLAGS=$WERCKER_HUGO_BUILD_FLAGS" --config="${WERCKER_SOURCE_DIR}/${WERCKER_HUGO_BUILD_CONFIG}
fi

if [ ! -n "$WERCKER_HUGO_BUILD_FORCE_INSTALL" ]; then
    WERCKER_HUGO_BUILD_FORCE_INSTALL=false
fi

#check if hugo is already installed in the container
if (! command_exists "hugo") || $WERCKER_HUGO_BUILD_FORCE_INSTALL = true; then
    install_hugo
else
    HUGO_COMMAND="hugo"
fi

eval ${HUGO_COMMAND} --source="${WERCKER_SOURCE_DIR}" ${WERCKER_HUGO_BUILD_FLAGS}
