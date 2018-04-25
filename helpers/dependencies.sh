#!/bin/bash
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

apk_install()
{
    if ! command_exists sudo; then
        apk add $1
    else
        sudo apk add $1
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
        if command_exists apk; then
            if ! command_exists sudo; then
                apk update
            else
                sudo apk update
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
      elif command_exists apk; then
          apk_install curl
      else
          yum_install curl
      fi
  fi
}

install_pygments()
{
    # check if pygments is installed
    # install otherwise
    if ! command_exists pygmentize; then
        echo "Installing Pyments"
        if command_exists pip; then
          pip install Pygments
        else
          update_sources
          if command_exists apt-get; then
              apt_install "python-pygments"
          elif command_exists pacman; then
              pacman_install "python-pygments"
          elif command_exists apk; then
              apk_install "python-pygments"
          else
              yum_install "python-pygments"
          fi
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
        elif command_exists apk; then
            apk_install "go git mercurial"
        else
            yum_install "golang git mercurial"
        fi
    fi
}
