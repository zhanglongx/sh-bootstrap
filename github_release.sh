#!/bin/bash
# A simple script to download and install the latest release of a GitHub repository
# the release assets should be packages (deb or rpm) for the current arch:
#  - <app>_<version>_<arch>.deb
#  - <app>-<version>-<rel-version>.<arch>.rpm
# FIXME: repository name should not contain 'deb' or 'rpm'

REPO_OWNER="zhanglongx"

show_help() {
  echo "Usage: $0 [-f] [repository]"
  echo
  echo "  -d            download only"
  echo "  -h            display help"
}

ONLY_DOWNLOAD=false

while getopts "dh" opt; do
  case $opt in
    d)
      ONLY_DOWNLOAD=true
      ;;
    h)
      show_help
      exit 0
      ;;
    *)
      show_help
      exit 1
      ;;
  esac
done

shift $((OPTIND - 1))

if [ $# -lt 1 ]; then
  echo "Error: repository argument is required."
  show_help
  exit 1
fi

REPOSITORY=$1

ARCH=$(uname -m)
if [ "$ARCH" == "x86_64" ]; then
  ARCH="amd64"
elif [ "$ARCH" == "aarch64" ]; then
  ARCH="arm64"
else
  echo "unsupported arch: $ARCH"
  exit 1
fi

if command -v dpkg >/dev/null; then
  PKG_TYPE="deb"
  INSTALL_CMD="sudo dpkg -i"
elif command -v rpm >/dev/null; then
  PKG_TYPE="rpm"
  INSTALL_CMD="sudo yum install -y"
  
  # convert arch to rpm arch
  if [ "$ARCH" == "amd64" ]; then
    ARCH="x86_64"
  elif [ "$ARCH" == "arm64" ]; then
    ARCH="aarch64"
  fi
else
  echo "unsupported package manager (dpkg or rpm)"
  exit 1
fi

# FIXME: specify version
LATEST_RELEASE=$(curl -s https://api.github.com/repos/$REPO_OWNER/$REPOSITORY/releases/latest)
if [ $? -ne 0 ]; then
  echo "failed to get latest release"
  exit 1
fi

DOWNLOAD_URL=$(echo "$LATEST_RELEASE" | grep "browser_download_url" | grep "$PKG_TYPE" | grep "$ARCH" | cut -d '"' -f 4)

if [ -z "$DOWNLOAD_URL" ]; then
  echo "failed to get download url"
  exit 1
fi

DELETE_TEMP_FILE=true
if [ "$ONLY_DOWNLOAD" == "true" ]; then
  FILENAME=$(basename "$DOWNLOAD_URL")
  DELETE_TEMP_FILE=false
else
  FILENAME=$(basename $(mktemp))
fi

curl -L -o $FILENAME "$DOWNLOAD_URL"
if [ $? -ne 0 ]; then
  echo "failed to download package from: $DOWNLOAD_URL"
  exit 1
fi

if [ "$ONLY_DOWNLOAD" == "false" ]; then
  $INSTALL_CMD "$FILENAME"
  if [ $? -ne 0 ]; then
    echo "failed to install package"
    exit 1
  fi
fi

if [ "$DELETE_TEMP_FILE" == "true" ]; then
  rm -f "$FILENAME"
fi
