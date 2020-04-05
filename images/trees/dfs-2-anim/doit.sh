for x in *.png; do convert $x -background white -flatten $(basename $x .png).jpg; done
convert -delay 50 -loop 0 *.jpg animatedGIF.gif
python -m http.server 8889
