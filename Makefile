confgen:
	@sh confgen.sh 1

run:
	@sh  run.sh 1

kill:
	pkill consul; true

ps:
	ps axu|grep consul

clean: kill
	rm -rf dc*

m1:
	consul members -rpc-addr=127.0.0.1:8400

m2:
	consul members -rpc-addr=127.0.0.1:9400

