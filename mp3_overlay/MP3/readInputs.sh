#!/bin/sh

read -t 0.2 mp3Com

case $mp3Com in
start)
echo '1' > /tmp/start_flag
;;
pause)
echo '1' > /tmp/pause_flag
;;
restart)
echo '1' > /tmp/restart_flag
;;
next)
echo '1' > /tmp/next_flag
;;
prev)
echo '1' > /tmp/prev_flag
;;
shuf)
echo '1' > /tmp/shuf_flag
esac

