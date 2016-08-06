#/bin/bash

LATEST_HUGO_VERSION=0.16

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

apt_install()
{
    if ! command_exists sudo; then
        apt-get install -y $1
    else
        sudo apt-get install -y $1
    fi
}

pacman_install()
{
    if ! command_exists sudo; then
        pacman -S --noconfirm $1
    else
        sudo pacman -S --noconfirm $1
    fi
}

yum_install()
{
    if ! command_exists sudo; then
        yum install -y $1
    else
        sudo yum install -y $1
    fi
}

SOURCES_UPDATED=false
update_sources()
{
    if [ "$SOURCES_UPDATED" = false ] ; then
        if command_exists apt-get; then
            if ! command_exists sudo; then
                apt-get update
            else
                sudo apt-get update
            fi
        fi
        if command_exists pacman; then
            if ! command_exists sudo; then
                pacman -Syu
            else
                sudo pacman -Syu
            fi
        fi
        SOURCES_UPDATED=true
    fi
}

install_curl()
{
  # check if curl is installed
  # install otherwise
  if ! command_exists curl; then
      update_sources
      if command_exists apt-get; then
          apt_install curl
      elif command_exists pacman; then
          pacman_install curl
      else
          yum_install curl
      fi
  fi
}

install_hugo()
{


    cd $WERCKER_STEP_ROOT
    if [ "$WERCKER_HUGO_BUILD_VERSION" == "HEAD" ]; then
        install_golang
        export GOPATH=$WERCKER_STEP_ROOT/gopath
        go get -v github.com/spf13/hugo
        HUGO_COMMAND=${GOPATH}/bin/hugo
    else
        curl -sL https://github.com/spf13/hugo/releases/download/v${WERCKER_HUGO_BUILD_VERSION}/hugo_${WERCKER_HUGO_BUILD_VERSION}_linux_amd64.tar.gz -o ${WERCKER_STEP_ROOT}/hugo_${WERCKER_HUGO_BUILD_VERSION}_linux_amd64.tar.gz
        tar xzf hugo_${WERCKER_HUGO_BUILD_VERSION}_linux_amd64.tar.gz
        HUGO_COMMAND=${WERCKER_STEP_ROOT}/hugo_${WERCKER_HUGO_BUILD_VERSION}_linux_amd64/hugo_${WERCKER_HUGO_BUILD_VERSION}_linux_amd64
    fi
}

install_pygments()
{
    # check if pygments is installed
    # install otherwise
    if ! command_exists pygmentize; then
        update_sources
        if command_exists apt-get; then
            apt_install "python-pygments"
        elif command_exists pacman; then
            pacman_install "python-pygments"
        else
            yum_install "python-pygments"
        fi
    fi
}

install_golang()
{
    # check if go is installed
    # install otherwise
    if ! command_exists go; then
        update_sources
        if command_exists apt-get; then
            apt_install "golang git mercurial"
        elif command_exists pacman; then
            pacman_install "go git mercurial"
        else
            yum_install "golang git mercurial"
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
    echo "The Hugo version in your wercker.yml isn't set correctly. Please put quotes around it. We will continue using the latest release ($LATEST_HUGO_VERSION)."
    WERCKER_HUGO_BUILD_VERSION=""
fi

if [ -z "$WERCKER_HUGO_BUILD_VERSION" ]; then
    WERCKER_HUGO_BUILD_VERSION=$LATEST_HUGO_VERSION
fi

if [ -z "$WERCKER_HUGO_BUILD_FLAGS" ]; then
    WERCKER_HUGO_BUILD_FLAGS=""
fi

if [ -z "$WERCKER_HUGO_BUILD_BASEDIR" ]; then
    WERCKER_HUGO_BUILD_BASEDIR=""
fi

if [ -n "$WERCKER_HUGO_BUILD_THEME" ]; then
    WERCKER_HUGO_BUILD_FLAGS=$WERCKER_HUGO_BUILD_FLAGS" --theme="${WERCKER_HUGO_BUILD_THEME}
fi

if [ -n "$WERCKER_HUGO_BUILD_CONFIG" ]; then
    WERCKER_HUGO_BUILD_FLAGS=$WERCKER_HUGO_BUILD_FLAGS" --config="${WERCKER_SOURCE_DIR}/${WERCKER_HUGO_BUILD_BASEDIR}/${WERCKER_HUGO_BUILD_CONFIG}
fi

if [ -n "$WERCKER_HUGO_BUILD_DEV_FLAGS" ] && check_branches; then
    WERCKER_HUGO_BUILD_FLAGS=${WERCKER_HUGO_BUILD_DEV_FLAGS}
fi

if [ -z "$WERCKER_HUGO_BUILD_FORCE_INSTALL" ]; then
    WERCKER_HUGO_BUILD_FORCE_INSTALL="false"
fi

if [ -z "$WERCKER_HUGO_BUILD_DISABLE_PYGMENTS" ]; then
    WERCKER_HUGO_BUILD_DISABLE_PYGMENTS="false"
fi

# install pygments if it's not disabled
if [ "$WERCKER_HUGO_BUILD_DISABLE_PYGMENTS" == "false" ]; then
    install_pygments
fi

#check if hugo is already installed in the container
if (command_exists "hugo") && $WERCKER_HUGO_BUILD_FORCE_INSTALL == "false"; then
  HUGO_COMMAND="hugo"
else
  # check if this version of Hugo is already installed in the step
  # If it exists, keep the current HUGO_COMMAND, otherwise install Hugo
  HUGO_COMMAND=${WERCKER_STEP_ROOT}/bin/hugo_$WERCKER_HUGO_BUILD_VERSION
  # Curl needs to be installed to handle (https) calls by Hugo
  install_curl
  if [ ! -f $HUGO_COMMAND ]; then
    install_hugo
  fi
fi

eval ${HUGO_COMMAND} --source="${WERCKER_SOURCE_DIR}/${WERCKER_HUGO_BUILD_BASEDIR}" ${WERCKER_HUGO_BUILD_FLAGS}
