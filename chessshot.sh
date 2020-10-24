#!/bin/bash

FEN=""

function chessshot_check {
  pushd /opt/chessshot/ &> /dev/null
  python3 -c "import numpy" &> /dev/null; if [ $? -gt 1 ]; then "Error: numpy not installed!"; exit 1; fi
  python3 -c "import opencv" &> /dev/null; if [ $? -gt 1 ]; then echo "Error: opencv not installed!"; exit 1; fi
  python3 -c "import scipy" &> /dev/null; if [ $? -gt 1 ]; then echo "Error: scipy not installed!"; exit 1; fi
  python3 -c "import pillow" &> /dev/null; if [ $? -gt 1 ]; then echo "Error: pillow not installed!"; exit 1; fi
  which git &> /dev/null; if [ $? -gt 1 ]; then echo "Error: git not installed!"; exit 1; fi
  which scrot &> /dev/null; if [ $? -gt 1 ]; then echo "Error: scrot not installed!"; exit 1; fi
  if [ ! -f "putzmain.py" ]; then echo "Error: chessputzer file putzmain.py not found!"; exit 1; fi
  if [ ! -f "putzlib.py" ]; then echo "Error: chessputzer file putzlib.py not found!"; exit 1; fi
  if [ ! -f "pbarrs.npz" ]; then echo "Error: chessputzer file pbarrs.npz not found!"; exit 1; fi
  popd &> /dev/null
}

function chessshot_prepare {
  pushd /opt/chessshot &> /dev/null
  scrot -s /dev/shm/board.png
  python3 putzmain.py -f /dev/shm/board.png -o /dev/shm/board.fen
  FEN=$(cat /dev/shm/board.fen | sed "1d")
  rm /dev/shm/board.{png,fen}
  popd &> /dev/null
}

function chessshot_lichess {
  which xclip &> /dev/null || echo "Error: xdg-open not installed!"
  chessshot_prepare
  xdg-open "https://lichess.org/editor/${FEN}"
}

function chessshot_clip {
  which xclip &> /dev/null || echo "Error: xclip not installed!"
  chessshot_prepare
  echo -n ${FEN} | xclip
  echo -n ${FEN} | xclip -sel clip
}

function chessshot_gui {
  which zenity &> /dev/null || echo "Error: zenity not installed!"
  chessshot_prepare
  cat <<EOF | zenity --text-info --title "Extracted FEN-data" --filename /dev/stdin
The following FEN-data has been extracted:

$FEN
EOF
}

function chessshot_terminal {
  chessshot_prepare
  cat <<EOF
The following FEN-data has been extracted:

$FEN
EOF
}

function chessshot_help {
  cat <<EOF
Error: unsupport command
Please use one of the following commands:
$0 lichess
$0 clip
$0 gui
$0 terminal
EOF
}

chessshot_check

if [ "$1" == "lichess" ]
then
  chessshot_lichess
elif [ "$1" == "clip" ]
then
  chessshot_clip
elif [ "$1" == "gui" ]
then
  chessshot_gui
elif [ "$1" == "terminal" ]
then
  chessshot_terminal
else
  chessshot_help
fi


