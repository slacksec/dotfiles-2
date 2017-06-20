#!/usr/bin/env bash

if [[ $(uname) == "Linux" ]]; then
  # Ubuntu
  if [ -f /etc/debian_version ]; then
    codename="$(lsb_release -c | awk '{print $2}')"
    sudo apt-get update
    sudo apt-get -y install build-essential libffi-dev libssl-dev python-dev \
    python-minimal python-pip python-setuptools
  fi

  # RHEL
  if [ -f /etc/redhat-release ]; then
    if [ -f /etc/os-release ]; then
      codename="$(gawk -F= '/^NAME/{print $2}' /etc/os-release)"
      if [[ $codename == "Fedora" ]]; then
        sudo dnf -y install python-devel python-dnf && \
        sudo dnf -y group install "C Development Tools and Libraries"
      fi
    fi
  fi
fi

# MacOS
if [[ $(uname) == "Darwin" ]]; then
  if ! xcode-select --print-path &> /dev/null; then
    xcode-select --install &> /dev/null
  fi
  command -v brew >/dev/null 2>&1
  BREW_CHECK=$?
  if [ $BREW_CHECK -eq 0 ]; then
    echo "Brew already installed"
    elif [ $BREW_CHECK -ne 0 ]; then
    /usr/bin/ruby -e \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  brew list | grep python >/dev/null 2>&1
  PYTHON_CHECK=$?
  if [ $PYTHON_CHECK -eq 0 ]; then
    echo "Python already installed"
    elif [ $PYTHON_CHECK -ne 0 ]; then
    brew install python
  fi
fi