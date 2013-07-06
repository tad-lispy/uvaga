PATH:=./node_modules/.bin/:$(PATH)

all: install build test start

clean:
	rm -rf lib/*
	rm -rf assets/scripts/app/*.js
	rm -rf assets/scripts/app/*.map

init:
	if [ -e npm-shrinkwrap.json ]; then rm npm-shrinkwrap.json;	fi
	npm install

build: clean init
	./node_modules/.bin/coffee -cm -o lib src
	./node_modules/.bin/coffee -cm assets/scripts/app/

dev: watch
	NODE_ENV=development DEBUG=uvaga,uvaga:*,persona,persona:* nodemon

watch: end-watch
	./node_modules/.bin/coffee -cmw -o lib src					& echo $$! > .watch_pid
	./node_modules/.bin/coffee -cmw assets/scripts/app/ & echo $$! > .watch_frontend_pid

end-watch:
	if [ -e .watch_pid ]; then kill `cat .watch_pid`; rm .watch_pid;	else	echo no .watch_pid file; fi
	if [ -e .watch_frontend_pid ]; then kill `cat .watch_frontend_pid`; rm .watch_frontend_pid; else echo no .watch_pid file; fi

start:
	npm start

test:
	npm test

docs:
	./node_modules/.bin/groc "src/*.coffee?(.md)" "src/**/*.coffee?(.md)" readme.md

clean-docs:
	rm -rf doc/*
