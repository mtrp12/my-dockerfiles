#!/usr/bin/env bash

set +x

if [[ "$#" -ne "1" ]]; then
    echo Expected 1 argument, found $#...
    exit 1
fi

services=$(docker-compose config --services)
match=$(printf "$services" | grep -o "^${1}$")
if [[ -z "$match" ]]; then
    echo Invalid parameter
    echo "Possible values are:"
    echo "$services"
    exit 1
fi

n_running=$(docker ps --no-trunc | grep $1 | wc -l)
n_running=$(($n_running + 1))

xhost +si:localuser:$USER
docker-compose up --scale "$1"=$n_running "$1"