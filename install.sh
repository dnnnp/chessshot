#!/bin/bash

set -e

if [ "$EUID" -ne 0 ]
then
  echo "Please run as root"
  exit 1
fi

function install {
  apt install python3 python3-pip python3-numpy python3-opencv python3-scipy python3-pillow zenity scrot xclip git -y
  if [ -d "/opt/chessshot" ]
  then
    echo "Installation directory /opt/chessshot already exists... Aborting."
    echo "For reinstallation please remove the directory."
    echo "sudo rm -rf /opt/chessshot"
    exit 1
  fi
  umask 022
  mkdir -p /opt/chessshot
  pushd /opt/chessshot
  git clone https://github.com/dnnnp/chessputzer.git
  mv chessputzer/{putzmain.py,putzlib.py,pbarrs.npz} .
  rm -rf chessputzer
  popd

  cp chessshot.sh /opt/chessshot/chessshot
  chmod 0755 /opt/chessshot/chessshot
  ln -s /opt/chessshot/chessshot /usr/local/bin/chessshot
}

function uninstall {
  echo "Warning: Installed additional packaged will not be removed."
  echo "Please install any unwanted packages by yourself:"
  echo "apt purge python3 python3-pip python3-numpy python3-opencv python3-scipy python3-pillow zenity scrot xclip git"

  rm /usr/local/bin/chessshot
  rm /opt/chessshot -rf
}

function help {
  cat << EOF
Please use one of the following commands:
sudo $0 install       - installs chessshot on this machine
sudo $0 uninstall     - uninstalls chessshot on this machine

Installation path will be /opt/chessshot
EOF
}

if [ "$1" == "install" ]
then
  install
elif [ "$1" == "uninstall" ]
then
  uninstall
else
  help
fi
