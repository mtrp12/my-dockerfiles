#!/usr/bin/env bash

for path in $(docker-compose config | grep -o \/home.*config[^:]*);do
	echo -n Creating dir: $path.....
	mkdir -p $path
	echo created
done

echo -n Creating dir: ~/Documents/docker/vscode-servers/rust.....
mkdir -p ~/Documents/docker/vscode-servers/rust
echo created

echo -n Creating dir: ~/Documents/docker/vscode-servers/cpp.....
mkdir -p ~/Documents/docker/vscode-servers/cpp
echo created
