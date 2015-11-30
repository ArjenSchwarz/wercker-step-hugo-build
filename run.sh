#/bin/bash

LATEST_HUGO_VERSION=0.15

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

SOURCES_UPDATED=false
update_sources()
{
    if [ "$SOURCES_UPDATED" = false ] ; then
        if command_exists apt-get; then
            apt-get update
        fi
        if command_exists pacman; then
            pacman -Syu
        fi
        SOURCES_UPDATED=true
    fi
}

install_hugo()
{
    # check if curl is installed
    # install otherwise
    if ! command_exists curl; then
        update_sources
        if command_exists apt-get; then
            apt-get install -y curl
        elif command_exists pacman; then
            pacman -S --noconfirm curl
        else
            yum install -y curl
        fi
    fi

    cd $WERCKER_STEP_ROOT
    curl -sL https://github.com/spf13/hugo/releases/download/v${WERCKER_HUGO_BUILD_VERSION}/hugo_${WERCKER_HUGO_BUILD_VERSION}_linux_amd64.tar.gz -o ${WERCKER_STEP_ROOT}/hugo_${WERCKER_HUGO_BUILD_VERSION}_linux_amd64.tar.gz
    tar xzf hugo_${WERCKER_HUGO_BUILD_VERSION}_linux_amd64.tar.gz
    HUGO_COMMAND=${WERCKER_STEP_ROOT}/hugo_${WERCKER_HUGO_BUILD_VERSION}_linux_amd64/hugo_${WERCKER_HUGO_BUILD_VERSION}_linux_amd64
}

install_pygments()
{
    # check if pygments is installed
    # install otherwise
    if ! command_exists pygmentize; then
        update_sources
        if command_exists apt-get; then
            apt-get install -y python3-pygments
        elif command_exists pacman; then
            pacman -S --noconfirm python-pygments
        else
            yum install -y python-pygments
        fi
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

if [ "$WERCKER_HUGO_BUILD_VERSION" == "false" ]; then
    echo "The Hugo version in your wercker.yml isn't set correctly. Please put quotes around it. We will continue using the latest version ($LATEST_HUGO_VERSION)."
    WERCKER_HUGO_BUILD_VERSION=""
fi

if [ -z "$WERCKER_HUGO_BUILD_VERSION" ]; then
    WERCKER_HUGO_BUILD_VERSION=$LATEST_HUGO_VERSION
fi

if [ -z "$WERCKER_HUGO_BUILD_FLAGS" ]; then
    WERCKER_HUGO_BUILD_FLAGS=""
fi

if [ -n "$WERCKER_HUGO_BUILD_THEME" ]; then
    WERCKER_HUGO_BUILD_FLAGS=$WERCKER_HUGO_BUILD_FLAGS" --theme="${WERCKER_HUGO_BUILD_THEME}
fi

if [ -n "$WERCKER_HUGO_BUILD_CONFIG" ]; then
    WERCKER_HUGO_BUILD_FLAGS=$WERCKER_HUGO_BUILD_FLAGS" --config="${WERCKER_SOURCE_DIR}/${WERCKER_HUGO_BUILD_CONFIG}
fi

if [ -n "$WERCKER_HUGO_BUILD_DEV_FLAGS" ] && check_branches; then
    WERCKER_HUGO_BUILD_FLAGS=${WERCKER_HUGO_BUILD_DEV_FLAGS}
fi

if [ -z "$WERCKER_HUGO_BUILD_FORCE_INSTALL" ]; then
    WERCKER_HUGO_BUILD_FORCE_INSTALL="false"
fi

if [ -z "$WERCKER_HUGO_DISABLE_PYGMENTS" ]; then
    WERCKER_HUGO_DISABLE_PYGMENTS="false"
fi

# install pygments if it's not disabled
if [ "$WERCKER_HUGO_DISABLE_PYGMENTS" == "false" ]; then
    install_pygments
fi

#check if hugo is already installed in the container
if (! command_exists "hugo") || $WERCKER_HUGO_BUILD_FORCE_INSTALL = "true"; then
    install_hugo
else
    HUGO_COMMAND="hugo"
fi

eval ${HUGO_COMMAND} --source="${WERCKER_SOURCE_DIR}" ${WERCKER_HUGO_BUILD_FLAGS}
