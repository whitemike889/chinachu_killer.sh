#!/bin/bash

#if someone except for X is logged in, killing is cancelled.
if [ `expr $(who | wc --lines) - $(who | grep unknown | wc --lines)` -gt 0 ] ; then
  exit
fi

#if someone is accessing chinachu, killing is cancelled.
if [ `netstat -t -n | grep 10772 | wc -l` -gt 0 ] ; then
  exit
fi

#if chinachu is recording now, killing is cancelled.
if [ `cat /home/chinachu/chinachu/data/recording.json | wc --chars` -gt 2 ] ; then
  END=`cat /home/chinachu/chinachu/data/recording.json | sed 's/"start":/\n/g' | sed "1d" | sed '/"isSkip":true/d' | cut -c 21-30 | sort | sed '2,$d'`
  at `date --date @$(expr $END + 300) +"%R %Y-%m-%d"` -f /home/foo/bar/chinachu_killer.sh
  exit
fi

#get the time when the next recording starts or ends.
START=`cat /home/chinachu/chinachu/data/reserves.json | sed 's/"start":/\n/g' | sed "1d" | sed '/"isSkip":true/d' | cut -c 1-10 | sort | sed '2,$d'`
if [ `expr $START - $(date --date now +%s)` -lt 0 ] ; then
  START=`cat /home/chinachu/chinachu/data/reserves.json | sed 's/"start":/\n/g' | sed "1d" | sed '/"isSkip":true/d' | cut -c 1-10 | sort | sed "1d" | sed '2,$d'`
  END=`cat /home/chinachu/chinachu/data/reserves.json | sed 's/"start":/\n/g' | sed "1d" | sed '/"isSkip":true/d' | cut -c 21-30 | sort | sed "1d" | sed '2,$d'`
else
  END=`cat /home/chinachu/chinachu/data/reserves.json | sed 's/"start":/\n/g' | sed "1d" | sed '/"isSkip":true/d' | cut -c 21-30 | sort | sed '2,$d'`
fi

at `date --date @$(expr $END + 300) +"%R %Y-%m-%d"` -f /home/foo/bar/chinachu_killer.sh

#if the next recording is scheduled within 30 minutes, killing is cancelled.
if [ `expr $START - $(date --date now +%s)` -lt 1800 ] ; then
  exit
fi

#wakealarm is set 3 minutes before the next recording starts.
echo 0 > /sys/class/rtc/rtc0/wakealarm
echo `expr $START - 180` > /sys/class/rtc/rtc0/wakealarm

# shutdown
/sbin/shutdown -h now
