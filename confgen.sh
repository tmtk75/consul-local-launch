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
p1=$(expr 7 + $dc_no)

for e in `seq 0 4`; do
  confdir=`pwd`/$dcname/$e
  mkdir -p $confdir
  confpath=$confdir/consul.conf

  server=false
  bootstrap_expect=''
  if [ "$e" -gt 0 ]; then
    start_join='"127.0.0.1:'${p1}'301"'
  fi
  if [ "$e" -lt 3 ]; then
    server=true
    bootstrap_expect='"bootstrap_expect": 3,'
  fi
cat<<EOF > $confpath
{
  "datacenter": "${dcname}",
  "data_dir": "$confdir",
  "log_level": "INFO",
  "ports": {
    "dns":  ${p1}6${e}0,
    "http": ${p1}5${e}0,
    "rpc": ${p1}4${e}0,
    "server": ${p1}3${e}0,
    "serf_lan": ${p1}3${e}1,
    "serf_wan": ${p1}3${e}2
  },
  "start_join": [$start_join],
  $bootstrap_expect
  "node_name": "node${e}",
  "server": $server
}
EOF
done
