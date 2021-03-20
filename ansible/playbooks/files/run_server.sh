#!/usr/bin/env bash

cd /opt/minecraft || exit
java -Xmx6G -Xms6G -jar server.jar nogui
