#!/usr/bin/env

dc_no=${1-1}
dcname=dc${dc_no}

if [ ! -e "$dcname" ]; then
  exit
fi

for e in `\ls $dcname`; do
  confpath=$dcname/$e
  consul agent -config-file=$confpath/consul.conf -advertise=127.0.0.1 &
  echo $confpath
  sleep 3;
done
