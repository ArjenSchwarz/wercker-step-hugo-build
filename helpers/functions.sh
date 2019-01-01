#!/bin/bash
command_exists()
{
    hash "$1" 2>/dev/null
}

# http://stackoverflow.com/a/8574392/1592358
contains_element ()
{
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

install_hugo()
{
    cd $WERCKER_STEP_ROOT
    if [ "$WERCKER_HUGO_BUILD_VERSION" == "HEAD" ]; then
        install_golang
        export GOPATH=$WERCKER_STEP_ROOT/gopath
        go get -v github.com/gohugoio/hugo
        HUGO_COMMAND=${GOPATH}/bin/hugo
    else
        EXTENDED_FLAG=""
        if [[ "${WERCKER_HUGO_BUILD_VERSION}" > "0.42.2" ]]; then
            EXTENDED_FLAG="extended_"
        fi
        curl -sL https://github.com/gohugoio/hugo/releases/download/v${WERCKER_HUGO_BUILD_VERSION}/hugo_${EXTENDED_FLAG}${WERCKER_HUGO_BUILD_VERSION}_Linux-64bit.tar.gz -o hugo_${WERCKER_HUGO_BUILD_VERSION}_Linux-64bit.tar.gz
        tar xzf hugo_${WERCKER_HUGO_BUILD_VERSION}_Linux-64bit.tar.gz
        HUGO_COMMAND=${WERCKER_STEP_ROOT}/hugo
    fi
}

# returns true (0) if we're on a development branch
check_branches ()
{
    if [ -n "$WERCKER_HUGO_BUILD_PROD_BRANCHES" ]; then
        arr=($WERCKER_HUGO_BUILD_PROD_BRANCHES)
        if contains_element "$WERCKER_GIT_BRANCH" "${arr[@]}"; then
            return 1
        fi
    elif [ -n "$WERCKER_HUGO_BUILD_DEV_BRANCHES" ]; then
        arr=($WERCKER_HUGO_BUILD_DEV_BRANCHES)
        if ! contains_element "$WERCKER_GIT_BRANCH" "${arr[@]}"; then
            return 1
        fi
    fi
    return 0
}
