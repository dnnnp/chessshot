#!/bin/bash

if [ "$1" == "browser" ]
then

elif [ "$1" == "clip" ]
then

elif [ "$1" == "gui" ]
then

elif [ "$1" == "gui" ]
then

else

fi

pushd /opt/chessputzer
scrot -s /dev/shm/board.png
python3 putzmain.py -f /dev/shm/board.png -o /dev/shm/board.fen
data=$(cat /dev/shm/board.fen | sed "1d")

echo -n ${data} | xclip
echo -n ${data} | xclip -sel clip

cat > /dev/shm/board.fen << EOF
The following data has been copied to your clipboard:

${data}
EOF
#zenity --text-info --filename /dev/shm/board.fen
rm /dev/shm/board.{png,fen}
popd
