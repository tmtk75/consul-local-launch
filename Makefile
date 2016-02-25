###
### Set up clusters
###
setup: dc1 dc2

run: setup
	@sh run.sh 1 &
	@sh run.sh 2 &

dc1:
	@sh confgen.sh 1

dc2:
	@sh confgen.sh 2

kill:
	pkill consul; true

ps:
	ps axu|grep consul

clean: kill
	rm -rf dc*

###
### Preparation after clusters launch
###
join-wan:
	consul join -rpc-addr=127.0.0.1:8400 -wan 127.0.0.1:8352

search1:
	curl -X PUT  \
	  -d '{"Datacenter": "dc1", "Node": "google", "Address": "www.google.com", "Service": {"Service": "search", "Port": 80}}' \
	  http://127.0.0.1:8500/v1/catalog/register

search2:
	curl -X PUT  \
	  -d '{"Datacenter": "dc2", "Node": "google", "Address": "www.google.com", "Service": {"Service": "search", "Port": 80}}' \
	  http://127.0.0.1:8550/v1/catalog/register

###
###
###
m1:
	consul members -rpc-addr=127.0.0.1:8400

m2:
	consul members -rpc-addr=127.0.0.1:8450

members-wan:
	consul members -wan

n1:
	curl localhost:8500/v1/catalog/nodes?pretty

n2:
	curl localhost:8550/v1/catalog/nodes?pretty

dig1:
	dig @127.0.0.1 -p 8600 consul.service.consul

dig2:
	dig @127.0.0.1 -p 8650 consul.service.consul

dig-search-dc1:
	dig @127.0.0.1 -p 8600 search.service.consul

dig-search-dc2:
	dig @127.0.0.1 -p 8650 search.service.consul

