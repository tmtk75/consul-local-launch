#!/usr/bin/env bash

usage() {
cat<<EOF
usage: $0 <dc-no>

  Generate config files for 3 servers + 2 clients as in a data center

EOF
}

[ -z "$1" ] && usage

dc_no=${1-1}
dcname=dc${dc_no}
pn=$(echo|awk "{print ($dc_no - 1)* 5}")

for e in `seq 0 4`; do
  nn=$(echo|awk "{print ($dc_no - 1)* 5 + $e}")
  confdir=`pwd`/$dcname/$nn
  mkdir -p $confdir
  confpath=$confdir/consul.conf

  server=false
  bootstrap_expect=''
  recursors=''
  if [ "$e" -gt 0 ]; then
    start_join='"127.0.0.1:83'${pn}'1"'
  fi
  if [ "$e" -lt 3 ]; then
    server=true
    bootstrap_expect='"bootstrap_expect": 3,'
    if [ "$dc_no" == 1 ]; then
      recursors='"recursors": ["8.8.8.8", "8.8.4.4"],'
    fi
  fi
cat<<EOF > $confpath
{
  "datacenter": "${dcname}",
  "data_dir": "$confdir",
  "log_level": "INFO",
  "ports": {
    "dns":  86${nn}0,
    "http": 85${nn}0,
    "rpc": 84${nn}0,
    "server": 83${nn}0,
    "serf_lan": 83${nn}1,
    "serf_wan": 83${nn}2
  },
  $recursors
  "start_join": [$start_join],
  $bootstrap_expect
  "node_name": "node${nn}",
  "server": $server
}
EOF
done
