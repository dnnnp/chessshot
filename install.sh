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
    
  popd
}



install