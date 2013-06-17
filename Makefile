PATH:=./node_modules/.bin/:$(PATH)

all: install build test start

clean:
	rm -rf lib/*

install:
	npm install

build: clean install
	./node_modules/.bin/coffee -c -o lib src

dev: watch
	ENVIRONMENT=development nodemon

watch: end-watch
	./node_modules/.bin/coffee -cw -o lib src & echo $$! > .watch_pid

end-watch:
	if [ -e .watch_pid ]; then kill `cat .watch_pid`; rm .watch_pid; else echo no .watch_pid file; fi

start:
	npm start

test:
	npm test

docs:
	./node_modules/.bin/groc "src/*.coffee?(.md)" "src/**/*.coffee?(.md)" readme.md

clean-docs:
	rm -rf doc/*
